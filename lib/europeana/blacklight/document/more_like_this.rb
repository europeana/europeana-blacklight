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
          mlt_params = { query: more_like_this_query, rows: 4, profile: 'rich' }
          blacklight_config = @response.blacklight_config
          repository = blacklight_config.repository_class.new(blacklight_config)
          repository.search(mlt_params).documents
        end

        # @return [String]
        def more_like_this_query
          field_queries = more_like_this_field_queries.join(' OR ')
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

        def more_like_this_field_queries
          more_like_this_logic.map do |component|
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
