# RedisEval

[![Build Status](https://travis-ci.org/i2bskn/redis_eval.svg)](https://travis-ci.org/i2bskn/redis_eval)
[![codecov](https://codecov.io/gh/i2bskn/redis_eval/branch/master/graph/badge.svg)](https://codecov.io/gh/i2bskn/redis_eval)

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
