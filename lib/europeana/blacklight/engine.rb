module Europeana
  module Blacklight
    class Engine < Rails::Engine
      engine_name 'europeana_blacklight'

      initializer 'europeana_blacklight.routes' do |_app|
        ::Blacklight::Routes.send(:include, Europeana::Blacklight::Routes)
      end
    end
  end
end
