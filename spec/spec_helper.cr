require "spec"
require "webmock"

require "./spec_constants"
require "../src/placeos-pulse"

Spec.before_each &->WebMock.reset
