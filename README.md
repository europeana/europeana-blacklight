# Europeana::Blacklight

Ruby gem providing an adapter to use the
[Europeana REST API](http://labs.europeana.eu/api/introduction/) as a data
source for [Blacklight](http://projectblacklight.org/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'europeana-blacklight',
  require: 'europeana/blacklight',
  git: 'https://github.com/europeana/europeana-blacklight.git
```

And then execute:

    $ bundle

## Usage

1. Get a Europeana API key from http://labs.europeana.eu/api/
2. Set the API key using:
  ```ruby
  Europeana::API.api_key = 'your_api_key'
  ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/europeana-blacklight/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
