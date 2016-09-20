$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'dotenv'
Dotenv.load

require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_casettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

require 'clubhouse_ruby'
