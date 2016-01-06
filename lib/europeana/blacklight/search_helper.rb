module Europeana
  module Blacklight
    ##
    # Local overrides for {Blacklight::SearchHelper}
    module SearchHelper
      # index arg counts from 0; API start param counts from 1
      def previous_and_next_document_params(index, window = 1)
        start = index + 1
        api_params = {}

        if start > 1
          api_params[:start] = start - window # get one before
          api_params[:rows] = 2 * window + 1 # and one after
        else
          api_params[:start] = start # there is no previous doc
          api_params[:rows] = 2 * window # but there should be one after
        end

        api_params
      end

      private

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
