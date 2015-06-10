module Europeana
  module Blacklight
    class Document
      ##
      # Methods for obtaining "more like this" documents
      module MoreLikeThis
        ##
        # Queries the API for items similar to a given document
        #
        # @param [Europeana::Blacklight::Document] doc
        # @return [Array<Europeana::Blacklight::Document>]
        def more_like_this
          mlt_params = { query: more_like_this_query, rows: 4, profile: 'rich' }
          blacklight_config = @response.blacklight_config
          repository = blacklight_config.repository_class.new(blacklight_config)
          repository.search(mlt_params).documents
        end

        # @param [Europeana::Blacklight::Document] doc
        # @return [String]
        def more_like_this_query
          field_queries = more_like_this_logic.map do |component|
            query = "#{component[:param]}: ("
            [component[:fields]].flatten.each do |field|
              query << fetch(field, []).compact.map { |v| '"' + v + '"' }.join(' OR ')
            end
            query << ")^#{component[:boost]}"
          end
          '(' + field_queries.join(' OR ') + ') NOT europeana_id:"' + self.id + '"'
        end

        def more_like_this_logic
          [
            { param: 'title', fields: 'title', boost: 0.3 },
            { param: 'who', fields: 'proxies.dcCreator', boost: 0.5 },
            { param: 'DATA_PROVIDER', fields: 'aggregations.edmDataProvider', boost: 0.2 },
            { param: 'what', fields: ['proxies.dcType', 'proxies.dcSubject', 'concepts.about'], boost: 0.8 },
          ]
        end
      end
    end
  end
end
