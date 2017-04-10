require 'httparty'

module WowzaCloud
  class Client
    include HTTParty

    base_uri 'https://api-sandbox.cloud.wowza.com/api/v1' 
    attr_reader :headers

    def initialize(params = {})
      @headers = {'wsc-api-key' => WowzaCloud.configuration.api_key, 'wsc-access-key' => WowzaCloud.configuration.access_key }
    end
  end
end
