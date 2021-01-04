require "./spec_helper"

include Pulse

describe Pulse do
  it "should generate a setup link from environment variables" do
    link = setup_link

    link.should be_a String
    link.should end_with "/setup"
    link.should eq "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}/setup"
  end

  # it "should generate a proof of work" do
  #   proof_of_work = generate_proof_of_work("myemail@mail.com")

    
  # end

  it "should form up json blob for setup" do
    setup_json = setup_json("https://localhost:3000", "gab@place.technology")
    setup_json.should be_a String
    setup_json.should start_with "{\"instance_primary_contact\":\"gab@place.technology\",\"instance_domain\":\"https://localhost:3000\",\"proof_of_work\":\"1:22:"
    
    setup_body = SetupBody.from_json(setup_json)
    setup_body.instance_domain.should eq "https://localhost:3000"
    setup_body.instance_primary_contact.should eq "gab@place.technology"
    
    # should generate a proof of work
    proof_of_work = setup_body.proof_of_work
    proof_of_work.should be_a String
    proof_of_work.should contain ":gab@place.technology::"
    proof_of_work.size.should be_close(67, 3)
    proof_of_work.should start_with "1:22:"
  end

  # test high level setup method
  it "should setup a placeos instance" do
    WebMock.stub(:post, "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}/setup")
      # with(body : setup_json)
      .to_return(status: 201, body: "")

    setup = Pulse.setup("gab@place.technology")
    # is this actually useful?
    setup.should be_a HTTP::Client::Response
    setup.status_code.should eq 201
  end

  pending "should setup a placeos instance with a custom domain" do
    # webmock?
    Pulse.setup("gab@place.technology", "customdomain.custom")
  end
end
