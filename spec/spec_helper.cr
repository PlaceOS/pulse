require "../src/pulse"
require "spec"

require "webmock"

Spec.before_each &->WebMock.reset
