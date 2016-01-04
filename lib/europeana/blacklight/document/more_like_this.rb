module Europeana
  module Blacklight
    class Document
      ##
      # Methods for obtaining "more like this" documents
      module MoreLikeThis
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
            { param: 'what', fields: ['proxies.dcType', 'proxies.dcSubject'], boost: 0.8 },
            { param: 'who', fields: 'proxies.dcCreator', boost: 0.5 },
            { param: 'title', fields: 'title', boost: 0.3 },
            { param: 'DATA_PROVIDER', fields: 'aggregations.edmDataProvider', boost: 0.2 }
          ]
        end

        def more_like_this_field_terms(*fields)
          fields.flatten.map do |field|
            fetch(field, []).compact[0..9]
          end.flatten
        end

        def more_like_this_field_queries(param = nil)
          logic = more_like_this_logic.select do |component|
            param.nil? || component[:param] == param
          end
          logic.map do |component|
            field_terms = more_like_this_field_terms(component[:fields])
            more_like_this_param_query(component[:param], field_terms, component[:boost])
          end.compact
        end

        def more_like_this_param_query(param, terms, boost)
          return nil unless terms.present?
          or_terms = terms.map do |v|
            '"' + Europeana::API::Search.escape(v) + '"'
          end.join(' OR ')
          "#{param}: (#{or_terms})^#{boost}"
        end
      end
    end
  end
end
