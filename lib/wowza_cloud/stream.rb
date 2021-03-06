module WowzaCloud
  class Stream < WowzaCloud::Client
		attr_accessor :aspect_ratio_height, :aspect_ratio_width, :billing_mode, :broadcast_location, :closed_caption_type, :connection_code, :connection_code_expires_at, 
                  :delivery_method, :delivery_protocols, :delivery_protocol, :delivery_type, :disable_authentication, :encoder, :hosted_page, :hosted_page_description, 
                  :hosted_page_logo_image, :hosted_page_sharing_icons, :hosted_page_title, :name, :password, :player_countdown, :player_countdown_at, :player_logo_image, 
                  :player_resposive, :player_type, :player_video_poster_image, :player_width, :recording, :remove_hosted_page_logo_image, :remove_player_video_poster_image, 
                  :source_url, :transcoder_type, :use_stream_source, :username, :video_fallback, :api_key, :access_key, :id, :low_latency, :target_delivery_protocol, 
                  :source_connection_information, :streaming_server, :stream_name, :player_id, :player_embed_code


    def self.all()
      result = []
      headers = {'wsc-api-key' => WowzaCloud.configuration.api_key, 'wsc-access-key' => WowzaCloud.configuration.access_key}
      raw_result = get('/live_streams', headers: headers)
      raw_result['live_streams'].each do |data|
        result << WowzaCloud::Stream.new(data)
      end
      return result
    end

    def self.get_stream(stream_id)
      headers    = {'wsc-api-key' => WowzaCloud.configuration.api_key, 'wsc-access-key' => WowzaCloud.configuration.access_key}
      raw_result = get("/live_streams/#{stream_id}", headers: headers)
      return WowzaCloud::Stream.new(raw_result['live_stream'])
    end


    def initialize(params = {})
      super
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

    #def destroy
      #raw_response = self.class.delete("/live_streams/#{self.id}", headers: @headers) 
      #return raw_response.code == 204
    #end
    
    def status
      raw_response = self.class.get("/live_streams/#{self.id}/state/", headers: @headers) 
      return raw_response['live_stream']['state']
    end

    alias state status

    def stats
      raw_response = self.class.get("/live_streams/#{self.id}/stats", headers: @headers) 
      return raw_response['live_stream']
    end

    def thumbnail
      raw_response = self.class.get("/live_streams/#{self.id}/thumbnail_url", headers: @headers) 
      return raw_response['live_stream']['thumbnail_url']
    end

    def start
      raw_response = self.class.put("/live_streams/#{self.id}/start", headers: @headers) 
      return raw_response['live_stream']['state']
    end

    def reset
      raw_response = self.class.put("/live_streams/#{self.id}/reset", headers: @headers) 
      return raw_response['live_stream']['state']
    end

    def stop
      raw_response = self.class.put("/live_streams/#{self.id}/stop", headers: @headers) 
      return raw_response['live_stream']['state']
    end

    # Returns the first active schedule attached to this stream, if one exists
    def schedule
      Schedule.all.select{|s| s.transcoder_id == @id && s.state == 'enabled' }.first
    end

    def schedules
      Schedule.all.select{|s| s.transcoder_id == @id } 
    end
  
  end
end
