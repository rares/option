# -*- encoding: utf-8 -*-
require File.expand_path('../lib/option/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Rob Ares"]
  gem.email         = [""]
  gem.description   = %q{Ruby port of Scala's Option Monad}
  gem.summary       = %q{Option attempts to be faithful to the useful parts of the scala api. We lose the type safety but still is quite useful when dealing with optional values.}
  gem.homepage      = "http://www.gitlab.com/rob.ares/option"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = "option"
  gem.require_paths = ["lib"]
  gem.version       = Option::VERSION

  gem.add_development_dependency "minitest", ">= 5.20.0"
end
