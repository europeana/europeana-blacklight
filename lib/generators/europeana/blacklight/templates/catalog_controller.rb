# -*- encoding : utf-8 -*-
class <%= controller_name.classify %>Controller < ApplicationController
  include Europeana::Blacklight::Catalog

  configure_blacklight do |config|
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
    config.add_facet_field 'YEAR'
    config.add_facet_field 'RIGHTS'

    # Send all facet field names to the API.
    config.add_facet_fields_to_solr_request!

    # Fields to be displayed in the object view, in the order of display.
    config.add_show_field 'agents.prefLabel', label: 'Agents'
    config.add_show_field 'agents.begin', label: 'Start date'
    config.add_show_field 'agents.end', label: 'End date'
    config.add_show_field 'proxies.dcType', label: 'Type'
    config.add_show_field 'proxies.dcCreator', label: 'Creator'
    config.add_show_field 'proxies.dcFormat', label: 'Format'
    config.add_show_field 'proxies.dcIdentifier', label: 'Identifier'
    config.add_show_field 'proxies.dctermsCreated', label: 'Created'
    config.add_show_field 'aggregations.webResources.dctermsCreated', label: 'Created'
    config.add_show_field 'proxies.dctermsExtent', label: 'Extent'
    config.add_show_field 'europeanaAggregation.edmCountry', label: 'Country'
    config.add_show_field 'edmDatasetName', label: 'Dataset name'
    config.add_show_field 'aggregations.edmIsShownAt', label: 'Is shown at'
    config.add_show_field 'aggregations.edmIsShownBy', label: 'Is shown by'
    config.add_show_field 'europeanaAggregation.edmLanguage', label: 'Language'
    config.add_show_field 'europeanaAggregation.edmPreview', label: 'Preview'
    config.add_show_field 'aggregations.edmProvider', label: 'Provider'
    config.add_show_field 'aggregations.edmDataProvider', label: 'Data provider'
    config.add_show_field 'aggregations.edmRights', label: 'Rights'
    config.add_show_field 'places.latitude', label: 'Latitude'
    config.add_show_field 'places.longitude', label: 'Longitude'
    config.add_show_field 'type', label: 'Type'
    config.add_show_field 'year', label: 'Year'

    # "fielded" search configuration.
    config.add_search_field('', label: 'All Fields')
    %w(title who what when where subject).each do |field_name|
      config.add_search_field(field_name)
    end
  end
end
