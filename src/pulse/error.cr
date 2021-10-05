class PlaceOS::Pulse::Error < Exception
  getter request

  def initialize(@request, response)
    super("#{request.name} request failed with #{response.status_code}:\n#{response.body}")
  end
end
