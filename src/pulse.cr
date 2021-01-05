require "placeos-models"
require "ulid"
require "hashcash"
require "placeos"
require "rethinkdb-orm"
require "http/client"
require "./constants"

require "./setup"
require "./heartbeat"

# TODO maybe separate out heartbeat and setup concerns so its not all messy in one module

module Pulse
  # TODO schedule tasks

  # def self.send_heartbeat
  #   heartbeat = Heartbeat.new.to_json
  #   post_to_client_portal(client_portal_link, heartbeat)
  # end

  def self.setup(users_email : String, instance_domain = "https://localhost:3000")
    body = setup_json(instance_domain, users_email)
    post_to_client_portal(client_portal_link + "/setup", body)
  end


# high level setup method

# high level heartbeat method

  private def post_to_client_portal(link : String, body)
    # maybe add key/secret encoding here
    HTTP::Client.post link, body: body
  end

  private def client_portal_link : String
    "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}"
  end

  # reeval if the methods below are nessessary

  # make this a SetupBody class method?
  private def setup_json(instance_domain : String, users_email : String)
    Setup.new(users_email, instance_domain).to_json
  end

  private def heartbeat_json
    Heartbeat.new.to_json
  end
end
