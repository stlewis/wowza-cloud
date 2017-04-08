require "spec_helper"

RSpec.describe WowzaCloud do
  let(:params){ YAML::load(File.read(File.expand_path(File.dirname(__FILE__) + "/../credentials.yml")))}
  it "has a version number" do
    expect(WowzaCloud::VERSION).not_to be nil
  end
end
