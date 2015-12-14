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
          if blacklight_params[:mlt].respond_to?(:more_like_this_query)
            doc = blacklight_params[:mlt]
          else
            doc_response = repository.find(blacklight_params[:mlt])
            doc = doc_response.documents.first
          end
          query = doc.more_like_this_query(blacklight_params[:mltf])
          append_to_query_param(api_parameters, query)
        end
      end
    end
  end
end
