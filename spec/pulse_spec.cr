require "./spec_helper"

include Pulse

describe Pulse do
  it "should generate a setup link from environment variables" do
    link = generate_setup_link

    link.should be_a String
    link.should end_with "/setup"

    # is this useless??
    link.should eq "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}/setup"
  end

  it "should generate a proof of work" do
    proof_of_work = generate_proof_of_work("myemail@mail.com")

    proof_of_work.should be_a String
    proof_of_work.should contain ":myemail@mail.com::"
    proof_of_work.size.should be_close(63, 3)
    proof_of_work.should start_with "1:22:"
  end

  it "should form up json blob for setup" do
    setup_json = setup_json("https://localhost:3000", "gab@place.technology")
    setup_json.should be_a String
    setup_json.should start_with "{\"instance_primary_contact\":\"gab@place.technology\",\"proof_of_work\":\"1:22:"
    setup_json.should end_with ",\"instance_domain\":\"https://localhost:3000\"}"

    setup_body = SetupBody.from_json(setup_json)
    setup_body.instance_domain.should eq "https://localhost:3000"
    setup_body.instance_primary_contact.should eq "gab@place.technology"
    setup_body.proof_of_work.should start_with "1:22:"
    setup_body.proof_of_work.size.should be_close(65, 5)
  end

  # test high level setup method
  it "should setup a placeos instance" do
    # webmock
    WebMock.stub(:post, "#{App::CLIENT_PORTAL_URI}")

    Pulse.setup("gab@place.technology")
  end

  pending "should setup a placeos instance with a custom domain" do
    # webmock?
    Pulse.setup("gab@place.technology", "customdomain.custom")
  end
end
