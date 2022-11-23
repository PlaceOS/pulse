require "spec"
require "webmock"

require "./spec_constants"
require "../src/placeos-pulse"

Spec.before_each &->WebMock.reset

Spec.before_suite do
  PgORM::Database.parse(ENV["PG_DATABASE_URL"])
end
