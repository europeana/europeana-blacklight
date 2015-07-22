$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'europeana/blacklight'
require 'coveralls'

Coveralls.wear! unless Coveralls.will_run?.nil?

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
