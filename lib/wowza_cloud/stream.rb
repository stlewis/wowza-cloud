module WowzaCloud
  class Stream < WowzaCloud::Client
		attr_accessor :aspect_ratio_height, :aspect_ratio_width, :billing_mode, :broadcast_location, :closed_caption_type, :delivery_method, :delivery_protocols, :delivery_protocol,
									:delivery_type, :disable_authentication, :encoder, :hosted_page, :hosted_page_description, :hosted_page_logo_image, :hosted_page_sharing_icons,
								  :hosted_page_title, :name, :password, :player_countdown, :player_countdown_at, :player_logo_image, :player_resposive, :player_type, 
									:player_video_poster_image, :player_width, :recording, :remove_hosted_page_logo_image, :remove_player_video_poster_image, :source_url, 
                  :transcoder_type, :use_stream_source, :username, :video_fallback, :api_key, :access_key, :id, :low_latency, :target_delivery_protocol, :source_connection_information,
                  :streaming_server, :stream_name, :player_id, :player_embed_code


    def self.all(parameters = {})
      result = []
      headers = {'wsc-api-key' => parameters['api_key'], 'wsc-access-key' => parameters['access_key']}
      raw_result = get('/', headers: headers)
      raw_result['live_streams'].each do |data|
        result << WowzaCloud::Stream.new(data)
      end
      return result
    end

    def self.get_stream(id, parameters = {})
      headers = {'wsc-api-key' => parameters['api_key'], 'wsc-access-key' => parameters['access_key']}
      raw_result = get("/live_streams/#{id}", headers: headers)
      return WowzaCloud::Stream.new(raw_result[1].first.merge(parameters))
    end


    def initialize(params = {})
      super(params)
      params.each do |k, v|
        instance_variable_set(:"@#{k}", v) if self.respond_to?("#{k}=")
      end
      if(conn_params = params['source_connection_information'])
        self.streaming_server = conn_params['primary_server']
        self.stream_name      = conn_params['stream_name']
        self.disable_authentication = conn_params['disable_authentication']
        self.username = conn_params['username']
        self.password = conn_params['password']
      end
    end
  
  end
end
