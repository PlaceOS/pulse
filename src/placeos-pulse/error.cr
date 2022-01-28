require "./request"

class PlaceOS::Pulse::Error < Exception
  def initialize(request, response)
    super("#{request.class} request failed with #{response.status_code}:\n#{response.body}")
  end

  def initialize(@message)
    super
  end
end
