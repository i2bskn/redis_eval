require "simplecov"
require "coveralls"
Coveralls.wear!

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  add_filter "spec"
  add_filter ".bundle"
end

require "bundler/setup"
require "redis_eval"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

LUA_SCRIPT_PATH = [File.expand_path("../lua_scripts", __FILE__)]
TEST_DB = "redis://localhost:6379/10"

RSpec.configure do |config|
  config.order = :random
  config.after(:each) {
    RedisEval.config.reset
    RedisEval.send(:script_cache).clear
  }
end
