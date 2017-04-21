require "bundler/setup"
require "simplecov"
require "coveralls"

Coveralls.wear!

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])

SimpleCov.start do
  add_filter "test"
  add_filter ".bundle"
end

require "redis_eval"

SCRIPTS_PATH  = Pathname.new(File.expand_path("../scripts", __FILE__))
REDIS_TEST_DB = 10
Redis.current = Redis.new(db: REDIS_TEST_DB)

require "minitest/autorun"
