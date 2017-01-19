# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape/kaminari/version'

Gem::Specification.new do |spec|
  spec.name          = "grape-kaminari"
  spec.version       = Grape::Kaminari::VERSION
  spec.authors       = ["Tymon Tobolski"]
  spec.email         = ["tymon.tobolski@monterail.com"]
  spec.description   = %q{kaminari paginator integration for grape API framework}
  spec.summary       = %q{kaminari integration for grape}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_runtime_dependency "grape"
  spec.add_runtime_dependency "kaminari"
  spec.add_runtime_dependency "kaminari-grape", "1.0.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 2.9'
end
