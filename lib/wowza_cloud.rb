require "wowza_cloud/version"
require "wowza_cloud/client"
require "wowza_cloud/stream"

module WowzaCloud
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new 
    yield(configuration)
  end

  class Configuration
    attr_accessor :api_key, :access_key
  end
end
