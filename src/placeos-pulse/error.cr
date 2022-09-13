require "./request"

class PlaceOS::Pulse::Error < Exception
  def initialize(request, response)
    @token_request = request.is_a?(::PlaceOS::Pulse::Token)
    super("#{request.class} request failed with #{response.status_code}:\n#{response.body}")
  end

  getter? token_request : Bool = false

  def initialize(@message)
    super
  end
end
