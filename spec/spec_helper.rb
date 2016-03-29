ENV['RAILS_ENV'] ||= 'test'

require 'coveralls'
Coveralls.wear! unless Coveralls.will_run?.nil?

require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'
require 'webmock/rspec'

require 'europeana/api'
Europeana::API.logger.level = Logger::ERROR

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    stub_request(:get, %r{https://www.europeana.eu/api/v2/record/[^/]+/[^/.]+\.json}).
      with(query: hash_including(:wskey)).
      to_return(body: '{"success":true}', headers: { 'content-type' => 'application/json' })

    stub_request(:get, 'https://www.europeana.eu/api/v2/search.json').
      with(query: hash_including(:wskey, :query)).
      to_return(body: '{"success":true}', headers: { 'content-type' => 'application/json' })
  end
end
