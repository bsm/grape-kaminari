$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'kaminari'
require 'grape'
require 'grape-kaminari'
require 'rack/test'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir['#{File.dirname(__FILE__)}/support/**/*.rb'].each {|f| require f}

I18n.enforce_available_locales = false

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.order = 'random'
end
