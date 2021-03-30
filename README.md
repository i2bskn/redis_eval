# RedisEval

[![Gem Version](https://badge.fury.io/rb/redis_eval.svg)](https://badge.fury.io/rb/redis_eval)
[![CI](https://github.com/i2bskn/redis_eval/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/i2bskn/redis_eval/actions?query=workflow%3ACI)

Evaluate Lua scripts with Redis.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "redis_eval"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis_eval

## Usage

Build and execute a script source as argument.

```ruby
script = RedisEval::Script.new("return {KEYS[1], ARGV[1]}")
script.execute([1], [2]) # => ["1", "2"]
```

Find and build scripts from a specific directory.

```ruby
scripts = RedisEval::ScriptSet.new("/path/to/script_dir")
scripts.hello.execute(keys, argv) # build /path/to/script_dir/hello.lua and run.
```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/i2bskn/redis_eval.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
