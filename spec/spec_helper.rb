$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'dotenv'
require 'vcr'
require 'json'

# Loads the contents of .env into ENV
# https://github.com/bkeepers/dotenv
Dotenv.load

# Configures VCR, which provides responses to our API calls
# https://github.com/vcr/vcr
VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_casettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

require 'clubhouse_ruby'
