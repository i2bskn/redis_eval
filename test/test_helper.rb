require "bundler/setup"
require "simplecov"
require "coveralls"

Coveralls.wear!

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter::new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])

SimpleCov.start do
  add_filter "spec"
  add_filter ".bundle"
end

require "redis_eval"

require "minitest/autorun"
