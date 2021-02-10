require "placeos-models"
require "ulid"
require "hashcash"
require "placeos"
require "rethinkdb-orm"
require "http/client"
require "tasker"
require "sodium"

class Pulse
  getter instance_id : String
  getter secret_key : String
  getter task : Tasker::CRON(HTTP::Client::Response)

  def initialize(
    @instance_id : String,
    @secret_key : String
  )
    @task = Tasker.cron("30 7 * * *") { heartbeat }
    # sends back an object - wil contain methods to stop the task
  end

  # TODO document
  def setup(email : String, domain = "http://localhost:3000")
    Message.new(@instance_id, @secret_key.hexbytes, Pulse::Setup.new(email, @secret_key, domain)).send("/setup")
  end

  # TODO document
  def heartbeat
    Message.new(@instance_id, @secret_key.hexbytes).send
  end
end

class Message < Pulse
  include JSON::Serializable
  getter message : Pulse::Heartbeat | Pulse::Setup
  getter signature : String
  getter instance_id
  getter portal_uri

  def initialize(
    @instance_id : String,
    secret_key : Bytes,
    @message = Pulse::Heartbeat.new,
    @portal_uri : String = "http://placeos.run"
  )
    @signature = (Sodium::Sign::SecretKey.new(secret_key).sign_detached @message.to_json).hexstring
  end

  def payload
    {instance_id: @instance_id, message: @message, signature: @signature}.to_json
  end

  def send(custom_uri : String? = "") # e.g. /setup
    HTTP::Client.post "#{@portal_uri}/instances/#{@instance_id}#{custom_uri}", body: payload.to_json
  end
end

require "./helpers/*"
