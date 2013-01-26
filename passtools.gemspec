# -*- encoding: utf-8 -*-
require File.expand_path('../lib/passtools/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Verba"]
  gem.email         = ["david@halcyonengineering.com"]
  gem.description   = %q{Ruby wrapper to access the Passtools API}
  gem.summary       = %q{Passtools API gem}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "passtools"
  gem.require_paths = ["lib"]
  gem.version       = Passtools::VERSION

  gem.add_dependency 'rest-client',  "~> 1.6.7"
  gem.add_dependency 'multi_json', "~> 1.5"
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'fakefs'
  
end
