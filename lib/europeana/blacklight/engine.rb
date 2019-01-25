# frozen_string_literal: true

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
    end
  end
end
