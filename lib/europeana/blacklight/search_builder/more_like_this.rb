module Europeana
  module Blacklight
    class SearchBuilder
      ##
      # Search builder methods for more like this queries
      module MoreLikeThis
        extend ActiveSupport::Concern

        included do
          default_processor_chain.unshift :add_mlt_to_api
        end
        
        def add_mlt_to_api(api_parameters)
          return unless blacklight_params[:mlt]
          repository = blacklight_config.repository_class.new(blacklight_config)
          doc_response = repository.find(blacklight_params[:mlt])
          query = doc_response.documents.first.more_like_this_query(blacklight_params[:mltf])
          append_to_query_param(api_parameters, query)
        end
      end
    end
  end
end
