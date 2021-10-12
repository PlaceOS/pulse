require "spec"
require "webmock"

require "../src/placeos-pulse"

Spec.before_each &->WebMock.reset
