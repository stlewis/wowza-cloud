require "spec_helper"

RSpec.describe WowzaCloud::Stream do
  let(:params){ YAML::load(File.read(File.expand_path(File.dirname(__FILE__) + "/../credentials.yml")))}
  let(:mock_stream_list){ JSON.parse(File.read(File.expand_path(File.dirname(__FILE__) + '/fixtures/stream_list_response.json'))) }
  let(:mock_status_response){ JSON.parse(File.read(File.expand_path(File.dirname(__FILE__) + '/fixtures/status_response.json'))) }

  before(:each) do
    allow(WowzaCloud::Stream).to receive(:get).and_return(mock_stream_list)
  end

  it "can pull lists of streams" do
    streams = WowzaCloud::Stream.all
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
    streams = WowzaCloud::Stream.all
    first_stream = streams.first
    stream_id = first_stream.id
  
    expect(WowzaCloud::Stream).to receive(:get).and_return(mock_stream_list.first)

    found_stream = WowzaCloud::Stream.get_stream(stream_id)

    expect(found_stream.id).to eq(first_stream.id)
  end

  it "returns the status of a stream" do
    expect(WowzaCloud::Stream).to receive(:get).and_return(mock_stream_list.first)
    expect(WowzaCloud::Stream).to receive(:get).and_return(mock_status_response)
    stream = WowzaCloud::Stream.get_stream('cktvgy4p')
    status = stream.status
    expect(status).to eq('started')
  end

  it "can delete a stream" do
    expect(WowzaCloud::Stream).to receive(:get).and_return(mock_stream_list.first)
    mock_delete = double(HTTParty::Response, {code: 204})
    expect(WowzaCloud::Stream).to receive(:delete).and_return(mock_delete)
    stream   = WowzaCloud::Stream.get_stream('cktvgy4p')
    stream.destroy
  end

end
