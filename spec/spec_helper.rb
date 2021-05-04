require 'rspec'
require 'grape-kaminari'
require 'rack/test'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path('./support/**/*.rb', __dir__)].sort.each {|f| require f }

I18n.enforce_available_locales = false

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.raise_errors_for_deprecations!
  config.order = 'random'
end
