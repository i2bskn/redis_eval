# RedisEval

[![Build Status](https://travis-ci.org/i2bskn/redis_eval.svg)](https://travis-ci.org/i2bskn/redis_eval)
[![Coverage Status](https://coveralls.io/repos/i2bskn/redis_eval/badge.svg?branch=master&service=github)](https://coveralls.io/github/i2bskn/redis_eval?branch=master)

Evaluate Lua scripts with Redis.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redis_eval'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis_eval

## Usage

#### Configurations

- `redis_options` [Hash] Generation options of Redis instance.
- `script_paths` [Array] Path to find a script file.

Example:

```ruby
RedisEval.configure do |config|
  config.redis_options = { url: "redis://localhost:6379/1" }
  config.script_paths = ["/path/to/script_dir"]
end
```

#### Basic usage

Build and execute the script path to argument.

```ruby
script = RedisEval.build("/path/to/script.lua")
script.execute
```

Directly by the code in the argument to build.

```ruby
script = RedisEval::Script.new("hello", "return 'Hello world!'")
script.execute
```

#### Find and Build

To build and looking for a script from name.  
This function must be set `script_paths` option.

```ruby
RedisEval.hello.execute # => Execute "/path/to/script_dir/hello.lua".
```

#### Script test

Test the script by execute the command.

```
$ redis_eval_test /path/to/script.lua 1 key1 argv1
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/i2bskn/redis_eval. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

