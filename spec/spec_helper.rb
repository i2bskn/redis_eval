require "bundler/setup"
require "redis_eval"

# Uncomment when debugging
# require "pry"

Redis.current = Redis.new(host: ENV["REDIS_HOST"]) if ENV.has_key?("REDIS_HOST")

Dir.glob("#{__dir__}/support/**/*.rb").sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
