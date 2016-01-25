module Europeana
  module Blacklight
    ##
    # URL routing for Europeana records
    class Routes
      def initialize(defaults = {})
        @defaults = defaults
      end

      def call(mapper, options = {})
        constraints id: %r{[^/]+/[^/]+} do
          mapper.post 'record/*id/track', action: 'track', as: 'track'
          mapper.get 'record/*id', action: 'show', as: 'show'
        end
      end
    end
  end
end
