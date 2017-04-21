require "bundler/setup"
require "simplecov"

SimpleCov.start do
  add_filter "test"
  add_filter ".bundle"
end

SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
if ENV["CI"] == "true"
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require "redis_eval"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

SCRIPTS_PATH  = Pathname.new(File.expand_path("../scripts", __FILE__))
REDIS_TEST_DB = 10
Redis.current = Redis.new(db: REDIS_TEST_DB)

require "minitest/autorun"
