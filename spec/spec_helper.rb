$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'europeana/blacklight'
require 'coveralls'
require 'webmock/rspec'

Coveralls.wear! unless Coveralls.will_run?.nil?

Europeana::API.logger.level = Logger::ERROR

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    stub_request(:get, %r{http://www.europeana.eu/api/v2/record/[^/]+/[^/.]+\.json}).
      with(query: hash_including(:wskey)).
      to_return(body: '{"success":true}', headers: { 'content-type' => 'application/json' })

    stub_request(:get, 'http://www.europeana.eu/api/v2/search.json').
      with(query: hash_including(:wskey, :query)).
      to_return(body: '{"success":true}', headers: { 'content-type' => 'application/json' })
  end
end
