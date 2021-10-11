# PlaceOS Pulse

[![CI](https://github.com/PlaceOS/pulse/actions/workflows/crystal.yml/badge.svg)](https://github.com/PlaceOS/pulse/actions/workflows/crystal.yml)

The [PlaceOS](https://placeoos.com) telemetry client.

## Usage

```crystal
require "placeos-pulse"

# Create a new Pulse client
pulse_client = PlaceOS::Pulse::Client.new

# Registers the instance with the PlaceOS Portal.
# The client periodically reports platform telemetry.
pulse_client.start
```

### Configuration

```
PULSE_SAAS           # Whether the instance is a SaaS instance or not, accepts `1, 0, true, false`
PULSE_INSTANCE_EMAIL # Email to register the admin of the instance against
PULSE_INSTANCE_ID    # Unique identifier for the instance
```

## Contributors

- [Gab Fitzgerald](https://github.com/GabFitzgerald) - creator
- [Caspian Baska](https://github.com/caspiano) - maintainer
- [Cameron Reeves](https://github.com/camreeves) - maintainer
