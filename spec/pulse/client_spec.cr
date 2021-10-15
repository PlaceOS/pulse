require "../spec_helper"

module PlaceOS::Pulse
  MOCK_INSTANCE_ID    = "mock-id"
  MOCK_INSTANCE_TOKEN = "mock-token"
  MOCK_INSTANCE_EMAIL = "test@place.tech"
  MOCK_PRIVATE_KEY    = "bfbd56cbd0a1e48f5766f7544b70223a7a613bb79ad0a9ef0e025f50ac7b84ab8f99e6c6e974a30389721aa4edf64ce2123dfcf741e24c50c4ccab7d89cde709"
  API_BASE            = "#{PLACE_PORTAL_URI}/api/portal/v1"

  def self.client(saas = false)
    Client.new(
      instance_id: MOCK_INSTANCE_ID,
      instance_token: MOCK_INSTANCE_TOKEN,
      private_key: MOCK_PRIVATE_KEY,
      email: MOCK_INSTANCE_EMAIL,
      saas: saas,
    )
  end

  describe Client do
    before_each do
      WebMock.reset
    end

    describe "#register" do
      it "registers an instance" do
        WebMock
          .stub(:post, "#{API_BASE}/register")
          .to_return(status: 201)

        pulse = client(saas: false)
        pulse.register
        pulse.registered.should be_true
      end

      it "registers a SaaS instance" do
        WebMock
          .stub(:post, "#{API_BASE}/register")
          .to_return(status: 201)

        WebMock
          .stub(:post, "#{API_BASE}/instances/#{MOCK_INSTANCE_ID}/token")
          .to_return(status: 200)

        pulse = client(saas: true)
        pulse.register
        pulse.registered.should be_true
      end
    end

    it "#heartbeat" do
      WebMock.stub(:put, "#{API_BASE}/instances/#{MOCK_INSTANCE_ID}/heartbeat")
        .to_return(status: 200)

      pulse = client
      pulse.heartbeat
    end
  end
end
