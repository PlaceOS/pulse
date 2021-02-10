require "./spec_helper"

describe Pulse::Setup do
  describe ".new" do
    it "with default args" do
      setup_object = Pulse::Setup.new("gab@place.technology", "b18e1d0045995ec3d010c387ccfeb984d783af8fbb0f40fa7db126d889f6dadd77f48b59caeda77751ed138b0ec667ff50f8768c25d48309a8f386a2bad187fb")

      setup_object.should be_a Pulse::Setup
      setup_object.instance_primary_contact.should eq "gab@place.technology"
      setup_object.instance_domain.should eq "http://localhost:3000"
      setup_object.proof_of_work.should contain ":gab@place.technology::"
      Hashcash.valid?(setup_object.proof_of_work, "gab@place.technology", bits: 22).should eq true
      setup_object.public_key.should be_a String
      setup_object.public_key.size.should eq 64
    end

    it "with custom domain" do
      setup_object2 = Pulse::Setup.new("gab@place.technology", "b18e1d0045995ec3d010c387ccfeb984d783af8fbb0f40fa7db126d889f6dadd77f48b59caeda77751ed138b0ec667ff50f8768c25d48309a8f386a2bad187fb", "http://localhost:3001")

      setup_object2.should be_a Pulse::Setup
      setup_object2.instance_primary_contact.should eq "gab@place.technology"
      setup_object2.instance_domain.should eq "http://localhost:3001"
      setup_object2.proof_of_work.should contain ":gab@place.technology::"
      setup_object2.public_key.should be_a String
      setup_object2.public_key.size.should eq 64
    end
  end
end
