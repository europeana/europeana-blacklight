module Europeana
  module Blacklight
    module Catalog
      extend ActiveSupport::Concern

      included do
        include ::Blacklight::Catalog
        include Europeana::Blacklight::SearchHelper

        self.search_params_logic = Europeana::Blacklight::SearchBuilder.default_processor_chain

        configure_blacklight do |config|
          # Adapter classes
          config.repository_class = Europeana::Blacklight::ApiRepository
          config.search_builder_class = Europeana::Blacklight::SearchBuilder
          config.response_model = Europeana::Blacklight::Response
          config.document_model = Europeana::Blacklight::Document
          config.document_presenter_class = Europeana::Blacklight::DocumentPresenter
          # config.facet_paginator_class = Europeana::Blacklight::FacetPaginator

          # Prevent BL's "did you mean" spellcheck feature kicking in
          config.spell_max = -1
        end
      end

      def has_search_parameters?
        super || params.key?(:q) # map empty search to *:* query wildcard
      end
    end
  end
end
