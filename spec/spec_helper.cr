require "spec"
require "webmock"

require "../src/pulse"

Spec.before_each &->WebMock.reset
