module Europeana
  module Blacklight
    # @todo keep classes here, but move rest to generated CatalogController?
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

          # Europeana API caching
          config.europeana_api_cache = Rails.cache
          config.europeana_api_cache_expires_in = 24.hours

          # Default parameters to send to Europeana for all search-like requests.
          # @see SolrHelper#solr_search_params
          config.default_solr_params = {
            rows: 24
          }

          # items to show per page, each number in the array represents another
          # option to choose from.
          config.per_page = [12, 24, 48, 96]

          # Field configuration for search results/index views
          config.index.title_field = 'title'
          config.index.display_type_field = 'type'
          config.index.timestamp_field = nil # Europeana's is in microseconds
          config.index.thumbnail_field = 'edmPreview'

          # Fields to be displayed in the index (search results) view
          # The ordering of the field names is the order of the display 
          # @see http://labs.europeana.eu/api/data-fields
          config.add_index_field 'edmAgentLabelLangAware', label: 'Creator'
          config.add_index_field 'dcDescription', label: 'Description'
          config.add_index_field 'edmConceptPrefLabelLangAware',
            separator: '; ', limit: 4, label: 'Subject'
          config.add_index_field 'year', label: 'Year'
          config.add_index_field 'dataProvider', label: 'Data provider'

          # Facet fields in the order they should be displayed.
          # @see http://labs.europeana.eu/api/search#individual-facets
          config.add_facet_field 'TYPE'
          config.add_facet_field 'REUSABILITY'
          config.add_facet_field 'COUNTRY'
          config.add_facet_field 'LANGUAGE'
          config.add_facet_field 'PROVIDER'
          config.add_facet_field 'DATA_PROVIDER'
          config.add_facet_field 'UGC', label: 'UGC'
          config.add_facet_field 'YEAR'
          config.add_facet_field 'RIGHTS'

          # Send all facet field names to the API.
          config.add_facet_fields_to_solr_request!

          # Fields to be displayed in the object view, in the order of display.
          config.add_show_field 'agents.prefLabel'
          config.add_show_field 'agents.begin'
          config.add_show_field 'agents.end'
          config.add_show_field 'proxies.dcType'
          config.add_show_field 'proxies.dcCreator'
          config.add_show_field 'proxies.dcFormat'
          config.add_show_field 'proxies.dcIdentifier'
          config.add_show_field 'proxies.dctermsCreated'
          config.add_show_field 'aggregations.webResources.dctermsCreated'
          config.add_show_field 'proxies.dctermsExtent'
          config.add_show_field 'proxies.dcTitle'
          config.add_show_field 'europeanaAggregation.edmCountry'
          config.add_show_field 'edmDatasetName'
          config.add_show_field 'aggregations.edmIsShownAt'
          config.add_show_field 'aggregations.edmIsShownBy'
          config.add_show_field 'europeanaAggregation.edmLanguage'
          config.add_show_field 'europeanaAggregation.edmPreview'
          config.add_show_field 'aggregations.edmProvider'
          config.add_show_field 'aggregations.edmDataProvider'
          config.add_show_field 'aggregations.edmRights'
          config.add_show_field 'places.latitude'
          config.add_show_field 'places.longitude'
          config.add_show_field 'type'
          config.add_show_field 'year'

          # "fielded" search configuration.
          config.add_search_field('', label: 'All Fields')
          %w(title who what when where subject).each do |field_name|
            config.add_search_field(field_name)
          end

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
