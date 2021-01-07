require "./spec_helper"

include Pulse

describe Pulse do
  # test setup method
  it "should setup a placeos instance" do
  # WebMock.stub(:post, "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}/setup")
    #   # with(body : setup_json)
    #   .to_return(status: 201, body: "")

    # setup = Pulse.setup("gab@place.technology")
    # # is this actually useful?
    # setup.should be_a HTTP::Client::Response
    # setup.status_code.should eq 201

    # finish this spec
  end


  # test setup method with custom somain

  # test hearbeat method
  
  
  it "should generate a client portal link from environment variables" do
    link = client_portal_link

    link.should be_a String
    link.should eq "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}"
  end
end
