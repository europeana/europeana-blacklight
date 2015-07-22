require 'europeana/blacklight/version'
require 'europeana/api'
require 'blacklight'

module Europeana
  ##
  # Adapter to use the Europeana REST API as a {Blacklight} data source
  module Blacklight
    autoload :ApiRepository, 'europeana/blacklight/api_repository'
    autoload :Document, 'europeana/blacklight/document'
    autoload :DocumentPresenter, 'europeana/blacklight/document_presenter'
    autoload :Response, 'europeana/blacklight/response'
    autoload :SearchBuilder, 'europeana/blacklight/search_builder'
  end
end
