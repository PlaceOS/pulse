require "secrets-env"

module App
  PLACEOS_INSTANCE_ID = ENV["PLACEOS_INSTANCE_ID"]? || abort "No Instance ID set in environment" # change this
  CLIENT_PORTAL_URI = ENV["CLIENT_PORTAL_URI"]? || "http://127.0.0.1:3000"

  # secret
  # private key
end
