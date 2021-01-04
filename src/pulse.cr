require "placeos-models"
require "ulid"
require "hashcash"
require "placeos"
require "rethinkdb-orm"
require "http/client"
require "./constants"

require "./setup_body"
require "./heartbeat_body"

# TODO maybe separate out heartbeat and setup concerns so its not all messy in one module

module Pulse
  # TODO schedule tasks

  def self.send_heartbeat
    post_to_client_portal(client_portal_link, heartbeat_json)
  end

  def self.setup(users_email : String, instance_domain = "https://localhost:3000")
    body = setup_json(instance_domain, users_email)
    post_to_client_portal(client_portal_link + "/setup", body)
  end

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
    SetupBody.new(users_email, instance_domain).to_json
  end

  private def heartbeat_json
    HeartbeatBody.new.to_json
  end
end
