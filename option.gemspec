# -*- encoding: utf-8 -*-
require File.expand_path('../lib/option/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Rob Ares"]
  gem.email         = ["rob.ares@gmail.com"]
  gem.description   = %q{Ruby port of Scala's Option Monad}
  gem.summary       = %q{Option attempts to be faithful to the useful parts of the scala api. We lose the type safety but still is quite useful when dealing with optional values.}
  gem.homepage      = "http://www.github.com/rares/option"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = "option"
  gem.require_paths = ["lib"]
  gem.version       = Option::VERSION

  gem.signing_key   = "/Volumes/External/gem-private_key.pem"
  gem.cert_chain    = ["gem-public_cert.pem"]

  gem.add_development_dependency "rake",     "= 0.9.2.2"
  gem.add_development_dependency "minitest", "= 3.4.0"
end
