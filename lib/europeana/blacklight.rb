# require 'active_support/core_ext/hash'
# require 'active_support/core_ext/module/delegation'
require 'blacklight'
# require 'europeana/api'
require 'europeana/blacklight/engine'

module Europeana
  ##
  # Adapter to use the Europeana REST API as a {Blacklight} data source
  module Blacklight
#     autoload :Document, 'europeana/blacklight/document'
    autoload :DocumentPresenter, 'europeana/blacklight/document_presenter'
    autoload :Repository, 'europeana/blacklight/repository'
    autoload :Response, 'europeana/blacklight/response'
    autoload :Routes, 'europeana/blacklight/routes'
    autoload :SearchBuilder, 'europeana/blacklight/search_builder'
    autoload :SearchHelper, 'europeana/blacklight/search_helper'
  end
end
