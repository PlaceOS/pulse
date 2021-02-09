require "placeos-models"
require "ulid"
require "hashcash"
require "placeos"
require "rethinkdb-orm"
require "http/client"
require "tasker"
require "./constants"
require "sodium"

require "./helpers/*"

module Pulse
  SECRET_KEY = Sodium::Sign::SecretKey.new(App::PLACEOS_INSTANCE_SECRET.hexbytes)

  def initialize
    Tasker.cron("30 7 * * *") { Pulse.heartbeat }
    # sends back an object - wil contain methods to stop the task
  end

  # TODO document
  def self.setup(email : String, domain = App::INSTANCE_DOMAIN)
    Sender.send(Pulse::Message.new(Pulse::Setup.new(email, domain)).payload, "/setup")
  end

  # TODO document
  def self.heartbeat
    Sender.send(Pulse::Message.new.payload)
  end
end

class Pulse::Message
  include JSON::Serializable
  getter message : Pulse::Heartbeat | Pulse::Setup
  getter signature : String

  def initialize(@message = Pulse::Heartbeat.new)
    @signature = (Pulse::SECRET_KEY.sign_detached @message.to_json).hexstring
  end

  def payload
    {message: @message.to_json, signature: @signature}.to_json
  end
end

module Pulse::Sender
  CLIENT_PORTAL_LINK = "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}"

  def self.send(body, custom_uri : String? = "")
    HTTP::Client.post CLIENT_PORTAL_LINK + custom_uri, body: body
  end
end
