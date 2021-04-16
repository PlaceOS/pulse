require "placeos-models"
require "ulid"
require "hashcash"
require "placeos"
require "rethinkdb-orm"
require "http/client"
require "tasker"
require "sodium"
require "uri"

class Pulse
  private getter instance_id : String
  private getter secret_key : Sodium::Sign::SecretKey
  private getter task : Tasker::Repeat(HTTP::Client::Response)

  def initialize(
    @instance_id : String,
    secret_key : String,
    heartbeat_interval : Time::Span = 1.day
  )
    @secret_key = Sodium::Sign::SecretKey.new(secret_key.hexbytes)
    @task = Tasker.every(heartbeat_interval) { heartbeat }
  end

  def heartbeat
    Message.new(@instance_id, @secret_key).send
  end

  def finalize
    @task.cancel
  end
end

class Message < Pulse
  include JSON::Serializable
  getter instance_id : String
  getter contents : Pulse::Heartbeat # revise type, make generic
  getter signature : String
  getter portal_uri : URI

  def initialize(
    @instance_id : String,
    secret_key : Sodium::Sign::SecretKey,
    @contents = Pulse::Heartbeat.new,
    @portal_uri : URI = URI.parse "http://placeos.run"
  )
    @signature = (secret_key.sign_detached @contents.to_json).hexstring
  end

  def payload
    {instance_id: @instance_id, contents: @contents, signature: @signature}.to_json
  end

  def send(custom_uri_path : String? = "") # e.g. /setup
    HTTP::Client.post "#{@portal_uri}/instances/#{@instance_id}#{custom_uri_path}", body: payload.to_json
  end
end

require "./helpers/*"
