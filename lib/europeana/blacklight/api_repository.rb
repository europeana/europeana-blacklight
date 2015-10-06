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
        res = cached(cache_key) do
          connection.record(id, params)
        end

        blacklight_config.response_model.new(
          res, params, document_model: blacklight_config.document_model,
                       blacklight_config: blacklight_config
        )
      end

      def search(params = {})
        cache_key = "Europeana:API:Search:" + params.to_query
        res = cached(cache_key) do
          connection.search(params)
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
        Europeana::API::Record.new(id).hierarchy.with_family
      rescue Europeana::API::Errors::RequestError => error
        unless error.message == 'This record has no hierarchical structure!'
          raise
        end
        false
      end

      ##
      # Queries the API for items similar to a given document
      def more_like_this(doc, field = nil, params = {})
        query = doc.more_like_this_query(field)
        return [nil, []] if query.nil?
        mlt_params = { query: query, rows: 4, profile: 'rich' }.merge(params)
        mlt_response = search(mlt_params)
        [mlt_response, mlt_response.documents]
      end

      def build_connection
        Europeana::API.tap do |api|
          api.api_key = blacklight_config.connection_config[:europeana_api_key]
        end
      end

      protected

      def cache
        @cache ||= begin
          blacklight_config.europeana_api_cache || ActiveSupport::Cache::NullStore.new
        end
      end

      def cache_expires_in
        @expires_in ||= begin
          blacklight_config.europeana_api_cache_expires_in || 24.hours
        end
      end

      def cached(key)
        cache.fetch(key, expires_in: cache_expires_in) do
          yield
        end
      end
    end
  end
end
