# frozen_string_literal: true

module Europeana
  module Blacklight
    module Catalog
      extend ActiveSupport::Concern

      include ::Blacklight::Catalog
      include Europeana::Blacklight::SearchHelper

      included do
        configure_blacklight do |config|
          # Adapter classes
          config.repository_class = Europeana::Blacklight::Repository
          config.search_builder_class = Europeana::Blacklight::SearchBuilder
          config.response_model = Europeana::Blacklight::Response
          config.document_model = Europeana::Blacklight::Document
          config.document_presenter_class = Europeana::Blacklight::DocumentPresenter

          # Prevent BL's "did you mean" spellcheck feature kicking in
          config.spell_max = -1
        end
      end

      # Empty search returns all records
      def has_search_parameters?
        super || params.key?(:q) || params.key?(:mlt)
      end

      def search_results(user_params)
        super.tap do |results|
          if has_search_parameters?
            results.first[:facet_queries] = europeana_api_query_facet_counts(user_params)
          end
        end
      end

      protected

      def blacklight_query_facets
        blacklight_config.facet_fields.select do |_, facet|
          facet.query &&
            (facet.include_in_request ||
            (facet.include_in_request.nil? &&
            blacklight_config.add_facet_fields_to_solr_request))
        end
      end

      def europeana_api_query_facet_counts(user_params)
        qf_counts = []

        blacklight_query_facets.each_pair do |_facet_name, query_facet|
          query_facet.query.each_pair do |_field_name, query_field|
            count = europeana_api_query_facet_count(query_field[:fq], user_params)
            qf_counts.push([query_field[:fq], count])
          end
        end

        qf_counts.sort_by(&:last).reverse.each_with_object({}) do |qf, hash|
          hash[qf.first] = qf.last
        end
      end

      def europeana_api_query_facet_count(query_field_fq, user_params)
        query = search_builder_class.new(search_params_logic, self).
                with(user_params).with_overlay_params(query_field_fq || {}).query.
                merge(rows: 0, start: 1, profile: 'minimal')
        repository.search(query).total
      end
    end
  end
end
