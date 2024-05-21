lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape/kaminari/version'

Gem::Specification.new do |spec|
  spec.name          = 'grape-kaminari'
  spec.version       = Grape::Kaminari::VERSION
  spec.authors       = ['Tymon Tobolski', 'Black Square Media']
  spec.email         = ['info@blacksquaremedia.com']
  spec.description   = 'kaminari paginator integration for grape API framework'
  spec.summary       = 'kaminari integration for grape'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject {|f| f.start_with?('spec/') }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.7'

  spec.add_runtime_dependency 'grape', '>= 1.6.1'
  spec.add_runtime_dependency 'kaminari-grape'

  spec.add_runtime_dependency 'dry-types', '<= 2.7.1' # 2.7.2 and above require ruby 3.0+

  spec.metadata['rubygems_mfa_required'] = 'true'
end
