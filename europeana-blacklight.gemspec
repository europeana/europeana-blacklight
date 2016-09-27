$:.push File.expand_path("../lib", __FILE__)

require 'europeana/blacklight/version'

Gem::Specification.new do |spec|
  spec.name          = 'europeana-blacklight'
  spec.version       = Europeana::Blacklight::VERSION
  spec.authors       = ['Richard Doe']
  spec.email         = ['richard.doe@rwdit.net']

  spec.summary       = 'Europeana REST API adapter for Blacklight'
  spec.homepage      = 'https://github.com/europeana/europeana-blacklight'
  spec.license       = 'EUPL-1.1'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'blacklight', '~> 6.0.0'
  spec.add_dependency 'europeana-api', '~> 0.5.2'
  spec.add_dependency 'iso-639', '~> 0.2.5'
  spec.add_dependency 'rails', '>= 4.2.2', '< 5'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec-rails', '~> 3.0'
  spec.add_development_dependency 'shoulda-matchers', '~> 2.8'
  spec.add_development_dependency 'webmock', '~> 1.21'
end
