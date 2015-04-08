# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'europeana/blacklight/version'

Gem::Specification.new do |spec|
  spec.name          = 'europeana-blacklight'
  spec.version       = Europeana::Blacklight::VERSION
  spec.authors       = ['Richard Doe']
  spec.email         = ['richard.doe@rwdit.net']

  spec.summary       = 'Europeana REST API adapter for Blacklight'
  spec.homepage      = 'https://github.com/europeana/europeana-blacklight'
  spec.license       = 'EUPL 1.1'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'blacklight', '~> 5.12.0'
  spec.add_dependency 'europeana-api', '~> 0.3.0'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
end
