require "./spec_helper"

describe Pulse::Setup do
  it "should create a new setup object" do
    setup_object = Pulse::Setup.new("gab@place.technology")

    setup_object.should be_a Pulse::Setup
    setup_object.instance_primary_contact.should eq "gab@place.technology"
    setup_object.instance_domain.should eq "http://localhost:3000"
    setup_object.proof_of_work.should contain ":gab@place.technology::"
    # Hashcash.verify?(setup_object.proof_of_work, "gab@place.technology", bits: 22).should eq true

    # custom domain
    setup_object2 = Pulse::Setup.new("gab@place.technology", "http://localhost:3001")

    setup_object2.should be_a Pulse::Setup
    setup_object2.instance_primary_contact.should eq "gab@place.technology"
    setup_object2.instance_domain.should eq "http://localhost:3001"
    setup_object2.proof_of_work.should contain ":gab@place.technology::"
  end

  it "should setup a placeos instance with class method" do
    WebMock.stub(:post, "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}/setup")
      .to_return(status: 201, body: "")

    setup_object = Pulse::Setup.new("gab@place.technology", "https://localhost:3000")
    response = setup_object.send
    response.should be_a HTTP::Client::Response
    response.status_code.should eq 201
  end
end
