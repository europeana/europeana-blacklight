# Europeana Blacklight Quick Start Guide

## Install Rails 4
```
gem install rails
rails -v
# Rails 4.2.5
```

## Create a new Rails application
```
rails new culture_vulture
cd culture_vulture
```

## Bundle europeana-blacklight
Add to the Gemfile:
```ruby
gem 'europeana-blacklight', '~> 0.3'
```

## Get a Europeana API key 
From http://labs.europeana.eu/api/

## Install Blacklight with the Europeana API adapter
```
bundle install
bundle exec rails generate blacklight:install --devise
bundle exec rails generate europeana:blacklight:install YOUR_API_KEY
bundle exec rake db:migrate
```

## Customise the config
Review the generated `CatalogController` and adjust the default configuration
to your preferences.

## Start the application
```
bundle exec rails server
```
