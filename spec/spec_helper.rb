require "bundler/setup"
require "wowza_cloud"

WowzaCloud.configure do |config|
  yaml_path         = File.dirname(__FILE__) + '/../credentials.yml'
  hsh               = YAML.load(File.read(yaml_path))
  config.api_key    = hsh['api_key']
  config.access_key = hsh['access_key']
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
