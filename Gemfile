source 'https://rubygems.org'

# Specify your gem's dependencies in europeana-blacklight.gemspec
gemspec

gem 'europeana-api', github: 'europeana/europeana-api-client-ruby', branch: 'develop'

group :test do
  gem 'coveralls', require: false
end

group :test, :development do
  gem 'rubocop', '0.39.0', require: false # only update when Hound does
end
