require "./spec_helper"

describe Pulse::Setup do
  # test initialise

  # test send - webmock
  it "should setup a placeos instance with class method" do
    WebMock.stub(:post, "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}/setup")
      # with(body : setup_json)
      .to_return(status: 201, body: "")

    setup = Pulse::Setup.new("gab@place.technology", "https://localhost:3000").send
    setup.should be_a HTTP::Client::Response
    setup.status_code.should eq 201

    # finish this spec
  end
end
