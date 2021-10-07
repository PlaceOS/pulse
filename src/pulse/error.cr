require "./message/request"

class PlaceOS::Pulse::Error < Exception
  getter request : Request

  def initialize(@request, response)
    super("#{request.class} request failed with #{response.status_code}:\n#{response.body}")
  end
end
