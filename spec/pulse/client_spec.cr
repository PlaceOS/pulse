require "../spec_helper"

module PlaceOS::Pulse
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
