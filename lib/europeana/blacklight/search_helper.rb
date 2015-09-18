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
    end
  end
end
