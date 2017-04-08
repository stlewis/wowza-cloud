require 'httparty'

module WowzaCloud
  class Client
    include HTTParty

    base_uri 'https://api-sandbox.cloud.wowza.com/api/v1/live_streams' 
    attr_reader :headers

    def initialize(parameters = {})
      @headers = {'wsc-api-key' => parameters['api_key'], 'wsc-access-key' => parameters['access_key']}
    end
  end
end
