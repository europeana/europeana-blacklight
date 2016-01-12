module Europeana
  module Blacklight
    class Engine < Rails::Engine
      engine_name 'europeana_blacklight'

      config.generators do |g|
        g.test_framework :rspec
      end

      config.autoload_paths += %W(
        #{config.root}/app/presenters
        #{config.root}/app/controllers/concerns
      )

#       initializer 'europeana_blacklight.routes' do |_app|
#         ::Blacklight::Routes.send(:include, Europeana::Blacklight::Routes)
#       end
    end
  end
end
