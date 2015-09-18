require 'europeana/blacklight/version'
require 'europeana/api'
require 'blacklight'
require 'europeana/blacklight/engine' if defined?(Rails)

module Europeana
  ##
  # Adapter to use the Europeana REST API as a {Blacklight} data source
  module Blacklight
    autoload :ApiRepository, 'europeana/blacklight/api_repository'
    autoload :Document, 'europeana/blacklight/document'
    autoload :DocumentPresenter, 'europeana/blacklight/document_presenter'
    # autoload :FacetPaginator, 'europeana/blacklight/facet_paginator'
    autoload :Response, 'europeana/blacklight/response'
    autoload :Routes, 'europeana/blacklight/routes'
    autoload :SearchBuilder, 'europeana/blacklight/search_builder'
    autoload :SearchHelper, 'europeana/blacklight/search_helper'
  end
end
