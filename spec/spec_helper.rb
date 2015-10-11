require "bundler/setup"
require "redis_eval"

RSpec.configure do |config|
  config.order = :random
  config.after(:each) { RedisEval.config.reset }
end
