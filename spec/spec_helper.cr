require "../src/pulse"
require "spec"

require "webmock"

Spec.before_each &->WebMock.reset

ENV["PORTAL_API_URI"] ||= "https://portal-dev.placeos.run"
PORTAL_API_URI = ENV["PORTAL_API_URI"]
ENV["JWT_PRIVATE_KEY"] ||= "<TEST KEY>" # This is just for testing and will be set in core