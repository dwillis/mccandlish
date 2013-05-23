# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mccandlish/version'

Gem::Specification.new do |spec|
  spec.name          = "mccandlish"
  spec.version       = Mccandlish::VERSION
  spec.authors       = ["Derek Willis"]
  spec.email         = ["dwillis@gmail.com"]
  spec.description   = %q{A thin, hopefully elegant Ruby wrapper for Version 2 of the NYT Article Search API}
  spec.summary       = %q{NYT Article Search API Ruby gem}
  spec.homepage      = ""
  spec.license       = "Apache"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "webmock"
  spec.add_dependency "oj"
  spec.add_dependency "httparty"
  spec.add_dependency "american_date"
end
