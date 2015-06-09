# Europeana::Blacklight

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
