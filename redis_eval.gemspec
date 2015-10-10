# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis_eval/version'

Gem::Specification.new do |spec|
  spec.name          = "redis_eval"
  spec.version       = RedisEval::VERSION
  spec.authors       = ["i2bskn"]
  spec.email         = ["i2bskn@gmail.com"]

  spec.summary       = %q{Evaluate Lua scripts with Redis.}
  spec.description   = %q{Evaluate Lua scripts with Redis.}
  spec.homepage      = "https://github.com/i2bskn/redis_eval"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "redis"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
