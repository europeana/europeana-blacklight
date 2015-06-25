module Europeana
  module Blacklight
    class Document
      ##
      # Methods for obtaining "more like this" documents
      module MoreLikeThis
        ##
        # Queries the API for items similar to a given document
        #
        # @return [Array<Europeana::Blacklight::Document>]
        def more_like_this
          query = more_like_this_query
          if !@response.respond_to?(:blacklight_config) || !query.nil?
            return [nil, []]
          end
          mlt_params = { query: query, rows: 4, profile: 'rich' }
          blacklight_config = @response.blacklight_config
          repository = blacklight_config.repository_class.new(blacklight_config)
          mlt_response = repository.search(mlt_params)
          [mlt_response, mlt_response.documents]
        end

        # @param [String] param Name of API parameter to restrict query to
        # @return [String]
        def more_like_this_query(param = nil)
          queries = more_like_this_field_queries(param)
          return nil unless queries.size > 0
          field_queries = queries.join(' OR ')
          "(#{field_queries}) NOT europeana_id:\"#{self.id}\""
        end

        protected

        def more_like_this_logic
          [
            { param: 'title', fields: 'title', boost: 0.3 },
            { param: 'who', fields: 'proxies.dcCreator', boost: 0.5 },
            { param: 'DATA_PROVIDER', fields: 'aggregations.edmDataProvider', boost: 0.2 },
            { param: 'what', fields: ['proxies.dcType', 'proxies.dcSubject', 'concepts.about'], boost: 0.8 },
          ]
        end

        def more_like_this_field_terms(*fields)
          fields.flatten.map do |field|
            fetch(field, []).compact
          end.flatten
        end

        def more_like_this_field_queries(param = nil)
          more_like_this_logic.select do |component|
            param.nil? || component[:param] == param
          end.map do |component|
            field_terms = more_like_this_field_terms(component[:fields])
            more_like_this_param_query(component[:param], field_terms, component[:boost])
          end.compact
        end

        def more_like_this_param_query(param, terms, boost)
          return nil unless terms.present?
          or_terms = terms.map { |v| '"' + v + '"' }.join(' OR ')
          "#{param}: (#{or_terms})^#{boost}"
        end
      end
    end
  end
end
