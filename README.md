# Europeana::Blacklight

[![Build Status](https://travis-ci.org/europeana/europeana-blacklight.svg?branch=master)](https://travis-ci.org/europeana/europeana-blacklight) [![Security](https://hakiri.io/github/europeana/europeana-blacklight/master.svg)](https://hakiri.io/github/europeana/europeana-blacklight/master) [![Maintainability](https://api.codeclimate.com/v1/badges/9ca73f2805dce1de01b6/maintainability)](https://codeclimate.com/github/europeana/europeana-blacklight/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/9ca73f2805dce1de01b6/test_coverage)](https://codeclimate.com/github/europeana/europeana-blacklight/test_coverage)

Ruby gem providing an adapter to use the
[Europeana REST API](http://labs.europeana.eu/api/introduction/) as a data
source for [Blacklight](http://projectblacklight.org/).

## Usage

See the [Quick Start Guide](QUICKSTART.md).

## Features

### Supported Blacklight features

* Search
* View record
* Pagination of search results
* Field facets
* [Query facets](#query-facets)
* Facet limits
* Fielded search
* Bookmarks
* Range queries

### Unsupported Blacklight features

* Result sorting :(
* "Did you mean" spellcheck
* MLT Solr-style (but see custom features)

### Custom features

* Nested EDM field names
* MLT by record ID in :mlt URL parameter
* Query facets with arbitrary API parameters

## Query facets

In the configuration for query facet fields, the `:fq` option is a `Hash`, to
permit specification of multiple parameters to be passed to the API:

```ruby
configure_blacklight do |config|
  config.add_facet_field 'Cities (reusable content)', query: {
    paris: { label: 'Paris', fq: { qf: 'paris', reusability: 'open' } },
    berlin: { label: 'Berlin', fq: { qf: 'berlin', reusability: 'open' } }
  }
end
```

*Warning:* query facets are achieved by sending additional queries to the
API. If you configure 2 query facets each with 10 facet values, this will result
in an additional 20 queries being sent to the API.

## License

Licensed under the EUPL v1.2.

For full details, see [LICENSE.md](LICENSE.md).
