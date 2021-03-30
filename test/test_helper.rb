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

# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

require "minitest/autorun"
