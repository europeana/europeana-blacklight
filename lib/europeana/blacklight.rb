require 'blacklight'
require 'europeana/blacklight/engine'

module Europeana
  ##
  # Adapter to use the Europeana REST API as a {Blacklight} data source
  module Blacklight
    autoload :DocumentPresenter, 'europeana/blacklight/document_presenter'
    autoload :Repository, 'europeana/blacklight/repository'
    autoload :Response, 'europeana/blacklight/response'
    autoload :Routes, 'europeana/blacklight/routes'
    autoload :SearchBuilder, 'europeana/blacklight/search_builder'
    autoload :SearchHelper, 'europeana/blacklight/search_helper'
  end
end
