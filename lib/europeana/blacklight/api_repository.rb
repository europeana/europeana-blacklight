require 'europeana/api'

module Europeana
  module Blacklight
    ##
    # Repository hooked up to Europeana REST API via europeana-api gem
    #
    # @see Europeana::API
    class ApiRepository < ::Blacklight::AbstractRepository
      ##
      # Finds a single Europeana record via the API
      #
      # @param id [String] record ID
      # @params params [Hash] request params to send to API
      # @return (see blacklight_config.response_model)
      def find(id, params = {})
        id = "/#{id}" unless id[0] == '/'
        cache_key = "Europeana:API:Record:#{id}"
        cache_key << ':' + params.to_query unless params.blank?
        res = Rails.cache.fetch(cache_key) do
          connection.record(id, auth_params(params))
        end

        blacklight_config.response_model.new(
          res, params, document_model: blacklight_config.document_model,
                       blacklight_config: blacklight_config
        )
      end

      def search(params = {})
        cache_key = "Europeana:API:Search:" + params.to_query
        res = Rails.cache.fetch(cache_key) do
          connection.search(auth_params(params))
        end

        blacklight_config.response_model.new(
          res, params, document_model: blacklight_config.document_model,
                       blacklight_config: blacklight_config
        )
      end

      ##
      # Fetches the hierarchy data for a Europeana record
      #
      # If the hierarchy data for the requested record is cached, that will be
      # returned, otherwise it will be obtained from the Europeana REST API.
      #
      # @param id [String] Europeana record ID, with leading slash
      # @return [Hash] Record's hierarchy data, or false if it has none
      def fetch_document_hierarchy(id)
        Rails.cache.fetch("Europeana:API:Record:hierarchy:#{id}") do
          begin
            europeana_api_document_hierarchy(id)
          rescue Europeana::API::Errors::RequestError => error
            unless error.message == 'This record has no hierarchical structure!'
              raise
            end
            false
          end
        end
      end

      ##
      # Requests hierarchy data for a Europeana record from the REST API
      #
      # The return value will contain a combination of the responses from the
      # ancestor-self-siblings and children API endpoints.
      #
      # @param id [String] Europeana record ID, with leading slash
      # @return [Hash] Record's hierarchy data
      def europeana_api_document_hierarchy(id)
        record = Europeana::API::Record.new(id, auth_params)
        hierarchy = record.hierarchy('ancestor-self-siblings')

        if hierarchy['self']['hasChildren']
          hierarchy = record.hierarchy('ancestor-self-siblings', :children)
        end

        hierarchy
      end

      def build_connection
        Europeana::API
      end

      protected

      def auth_params(params = {})
        {
          wskey: blacklight_config.connection_config[:europeana_api_key]
        }.merge(params)
      end
    end
  end
end
