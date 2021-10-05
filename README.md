# PlaceOS Pulse

[![CI](https://github.com/PlaceOS/pulse/actions/workflows/crystal.yml/badge.svg)](https://github.com/PlaceOS/pulse/actions/workflows/crystal.yml)

The [PlaceOS](https://placeoos.com) telemetry client.

## Usage

```crystal
require "pulse"
```

```crystal
# The instance needs to the URI of the portal to register with
export PLACE_PORTAL_URI=https://portal-dev.placeos.run
```

```crystal

# Create a new Pulse client which registers this instance with the PlaceOS Portal and creates a heartbeat running once a day
pulse_client = PlaceOS::Pulse::Client.new
pulse_client.registered
# => true

# If this is not a SaaS instance we can pass in `false` as the first param and the instance's private key won't be shared with the portal
pulse_client = PlaceOS::Pulse::Client.new(false)
pulse_client.saas
# => false

# If an instance ID and corresponding private key already exist they can be passed in
instance_id = ULID.generate
private_key = Sodium::Sign::SecretKey.new.to_slice.hexstring
pulse_client = PlaceOS::Pulse::Client.new(false, instance_id, private_key)
pulse_client.instance_id == instance_id
# => true

# The frequency which an instance sends heartbeats can be defined with the heartbeat_interval param
pulse_client = PlaceOS::Pulse::Client.new(heartbeat_interval: 1.hour)
```

Initialising the client will create an automated task which PUTs to `<PLACE_PORTAL_URI>/instances/<INSTANCE_ID>/heartbeat` with the frequency defined by the `heartbeat_interval` param which defaults to one per day.

## Contributors

- [Gab Fitzgerald](https://github.com/GabFitzgerald) - creator
- [Caspian Baska](https://github.com/caspiano) - maintainer
- [Cameron Reeves](https://github.com/camreeves) - maintainer
