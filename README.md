# Europeana::Blacklight

[![Build Status](https://travis-ci.org/europeana/europeana-blacklight.svg?branch=master)](https://travis-ci.org/europeana/europeana-blacklight) [![Coverage Status](https://coveralls.io/repos/europeana/europeana-blacklight/badge.svg?branch=master&service=github)](https://coveralls.io/github/europeana/europeana-blacklight?branch=master) [![security](https://hakiri.io/github/europeana/europeana-blacklight/master.svg)](https://hakiri.io/github/europeana/europeana-blacklight/master)

Ruby gem providing an adapter to use the
[Europeana REST API](http://labs.europeana.eu/api/introduction/) as a data
source for [Blacklight](http://projectblacklight.org/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'europeana-blacklight',
  github: 'europeana/europeana-blacklight',
  require: 'europeana/blacklight'
```

And then execute:

    $ bundle

## Usage

1. Get a Europeana API key from http://labs.europeana.eu/api/
2. Set the API key in `config/blacklight.yml`:
    
    ```yml
    production:
      europeana_api_key: YOUR_API_KEY
    ```
    
3. Configure Blacklight to use the Europeana API adapter:
    
    ```ruby
    class CatalogController < ApplicationController
      self.search_params_logic = Europeana::Blacklight::SearchBuilder.default_processor_chain

      configure_blacklight do |config|
        config.repository_class = Europeana::Blacklight::ApiRepository
        config.search_builder_class = Europeana::Blacklight::SearchBuilder
        config.response_model = Europeana::Blacklight::Response
        config.document_model = Europeana::Blacklight::Document
        config.document_presenter_class = Europeana::Blacklight::DocumentPresenter
        config.facet_paginator_class = Europeana::Blacklight::FacetPaginator
      end
    end
    ```

4. Caching (optional)

   To enable caching of API responses:

   ```ruby
   configure_blacklight do |config|
     config.europeana_api_cache = Rails.cache # or any {ActiveSupport::Cache} instance
     config.europeana_api_cache_expires_in = 60.minutes # defaults to 24.hours
   end
   ```
