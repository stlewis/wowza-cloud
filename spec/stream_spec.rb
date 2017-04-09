require "spec_helper"

RSpec.describe WowzaCloud::Stream do
  let(:params){ YAML::load(File.read(File.expand_path(File.dirname(__FILE__) + "/../credentials.yml")))}
  let(:mock_stream_list){ JSON.parse(File.read(File.expand_path(File.dirname(__FILE__) + '/fixtures/stream_list_response.json'))) }

  before(:each) do
    allow(WowzaCloud::Stream).to receive(:get).and_return(mock_stream_list)
  end

  it "can pull lists of streams" do
    streams = WowzaCloud::Stream.all(params) 
    expect(streams.first.class).to eq(WowzaCloud::Stream)
  end

  it "allows parameter setting upon initialization" do
    init_params = params.merge({
      'aspect_ratio_height'  => '1080',
      'aspect_ratio_width'   => '1920'
    })  
    stream = WowzaCloud::Stream.new(init_params)
    
    expect(stream.aspect_ratio_height).to eq init_params['aspect_ratio_height']
    expect(stream.aspect_ratio_width).to eq init_params['aspect_ratio_width']
  end

  it "allows pulling a stream by id" do
    streams = WowzaCloud::Stream.all(params)
    first_stream = streams.first
    stream_id = first_stream.id

    expect(WowzaCloud::Stream).to receive(:get).and_return(mock_stream_list.first)

    found_stream = WowzaCloud::Stream.get_stream(stream_id, params)

    expect(found_stream.id).to eq(first_stream.id)
  end

end