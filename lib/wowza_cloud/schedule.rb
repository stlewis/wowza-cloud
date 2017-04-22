require 'active_support/time'

module WowzaCloud
  class Schedule < WowzaCloud::Client

    attr_accessor :action_type, :begins_at, :created_at, :end_repeat, :ends_at, :id, :name, :recurrence_data, :start_repeat,
                  :state, :transcoder_id, :transcoder_name, :updated_at, :start_transcoder, :stop_transcoder


    def self.all()
      result = []
      headers = {'wsc-api-key' => WowzaCloud.configuration.api_key, 'wsc-access-key' => WowzaCloud.configuration.access_key}
      raw_result = get('/schedules', headers: headers) 
      raw_result['schedules'].each do |data| result << WowzaCloud::Schedule.new(data) end
      return result
    end

    def self.get_schedule(schedule_id)
      headers    = {'wsc-api-key' => WowzaCloud.configuration.api_key, 'wsc-access-key' => WowzaCloud.configuration.access_key}
      raw_result = get("/schedules/#{schedule_id}", headers: headers)
      return WowzaCloud::Schedule.new(raw_result['schedule'])
    end


    def initialize(params = {})
      super
      params.each do |k, v|
        instance_variable_set(:"@#{k}", v) if self.respond_to?("#{k}=")
      end
    end

    def start_time
      Time.parse(Time.parse(@start_transcoder).strftime("%H:%M:%S"))
    end

    def end_time
      Time.parse(Time.parse(@stop_transcoder).strftime("%H:%M:%S"))
    end

    def status
      raw_response = self.class.get("/schedules/#{self.id}/state/", headers: @headers) 
      return raw_response['schedule']['state']
    end

    alias state status

    def enable
      raw_response = self.class.put("/schedules/#{self.id}/enable", headers: @headers) 
      return raw_response['schedule']['state']
    end

    def disable
      raw_response = self.class.put("/schedules/#{self.id}/disable", headers: @headers) 
      return raw_response['schedule']['state']
    end

    def stream
      Stream.get_stream(@transcoder_id) 
    end
  
  end
end
