## v1.0.1 (2023-03-16)

### Refactor

- migrate to pg-orm models ([#24](https://github.com/PlaceOS/pulse/pull/24))

## v1.0.0 (2022-09-13)

### Fix

- token publish only occurs on first launch ([#23](https://github.com/PlaceOS/pulse/pull/23))

## v0.14.0 (2022-09-03)

### Feat

- remove libsodium ([#22](https://github.com/PlaceOS/pulse/pull/22))

## v0.13.2 (2022-03-09)

### Fix

- loosen `placeos-models` constraint ([#21](https://github.com/PlaceOS/pulse/pull/21))

## v0.13.1 (2022-03-01)

### Fix

- resolve internally breaking change

## v0.13.0 (2022-02-28)

### Fix

- **client**: update client init with new params
- **register**: add support for domain and name in specs
- **register**: add domain and name to registration request

## v0.12.0 (2022-01-28)

### Refactor

- unfortunate workaround

## v0.11.1 (2022-01-28)

## v0.11.0 (2021-12-06)

### Feat

- **features**: allow creation of Message::Heartbeat::Feature from json

### Fix

- **heartbeat**: just use a string when serialising feature key name
- **register**: fix hashcash validation method for pow ([#18](https://github.com/PlaceOS/pulse/pull/18))

### Refactor

- **message**: make `Message` abstract on the request body

## v0.10.0 (2021-10-27)

### Fix

- update from_environment

## v0.9.0 (2021-10-25)

### Feat

- add `Register#valid?`
- send public key with register request ([#16](https://github.com/PlaceOS/pulse/pull/16))

## v0.6.0 (2021-10-12)

### Refactor

- scope constants beneath `PLACE_`

## v0.5.1 (2021-10-12)

### Fix

- supply token arg in `from_environment`

## v0.5.0 (2021-10-12)

### Fix

- require path amendment

## v0.4.2 (2021-10-12)

## v0.4.1 (2021-10-12)

## v0.4.0 (2021-10-12)

### Feat

- add system and zone counts

### Fix

- use device modules for mocks

## v0.3.0 (2021-10-07)

### Feat

- **error**: add scoped error
- **heartbeat**: add module type counts
- **constants**: seperate constants from codebase
- **heartbeat**: add logic to count saas features
- **client**: add saas as a getter
- **specs**: update specs to use new flow
- **restructure**: move classe s into their own files and slight updates to message logic
- **register**: add logic for registration based off issues [#179](https://github.com/PlaceOS/pulse/pull/179), [#180](https://github.com/PlaceOS/pulse/pull/180) and [#181](https://github.com/PlaceOS/pulse/pull/181)
- **structure**: restructure directory to cleaner format
- desks
- finalize method to stop heartbeat
- signing with sodium implemented into heartbeat
- send hb method drafted
- setup comms with local client portal
- enter you email
- json blobs drafted
- pulling in models succcessfully - WIP

### Fix

- **spec**: update specs to new API
- super instead of raise
- missing requires
- get code to compile
- **pulse**: use PUT not POST to send heartbeat
- **saas**: default saas to true as initial instances will be saas
- **heartbeat**: fix naming and crystal client issues
- **heartbeat**: change heartbeat route to /heartbeat
- easy pr feedback fixes
- constants fix

### Refactor

- **client**: remove jwt encryption
- generalize message, simplify client
- scope beneath `PlaceOS`
- remove placeos client
- use a single portal uri constant
- use constant references
- **heartbeat**: db and client methods
- **message**: prevent any chance of _serializing the private key_
