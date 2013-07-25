# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'toys/version'

Gem::Specification.new do |spec|
  spec.name          = "toys"
  spec.version       = Toys::VERSION
  spec.authors       = ["Scott M Parrish"]
  spec.email         = ["anithri@gmail.com"]
  spec.description   = "Toys generate containers full of stuff to use when playing in irb"
  spec.summary       = ""
  spec.homepage      = "http://github.com/anithri/toys"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "koremutake", "0.1.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
