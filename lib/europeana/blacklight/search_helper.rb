module Europeana
  module Blacklight
    ##
    # Local overrides for {Blacklight::SearchHelper}
    module SearchHelper
      def previous_and_next_document_params(index, window = 1)
        api_params = {}

        if index > 1
          api_params[:start] = index - window # get one before
          api_params[:rows] = 2 * window + 1 # and one after
        else
          api_params[:start] = 1 # there is no previous doc
          api_params[:rows] = 2 * window # but there should be one after
        end

        api_params
      end

      def fetch_with_hierarchy(id, extra_controller_params = {})
        response, document = fetch(id, extra_controller_params)
        response.documents.first.hierarchy = europeana_record_hierarchy(id)
        [response, response.documents.first]
      end

      private

      def europeana_record_hierarchy(id)
        hierarchy = repository.fetch_document_hierarchy(id)
        hierarchy.nil? ? nil : {
          self: blacklight_config.document_model.new(hierarchy),
          parent: hierarchy.parent.present? ? blacklight_config.document_model.new(hierarchy.parent) : nil,
          children: hierarchy.children.map { |c| blacklight_config.document_model.new(c) },
          preceding_siblings: hierarchy.preceding_siblings.map { |s| blacklight_config.document_model.new(s) },
          following_siblings: hierarchy.following_siblings.map { |s| blacklight_config.document_model.new(s) }
        }
      end

      def fetch_many(ids = [], *args)
        if args.length == 1
          user_params = params
          extra_controller_params = args.first || {}
        else
          user_params, extra_controller_params = args
          user_params ||= params
          extra_controller_params ||= {}
        end

        id_query = ids.map { |id| "europeana_id:\"/#{id}\"" }.join(' OR ')

        query = search_builder.with(user_params).where(id_query)
        api_response = repository.search(query.merge(extra_controller_params))

        [api_response, api_response.documents]
      end
    end
  end
end
