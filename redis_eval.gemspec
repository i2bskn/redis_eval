lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "redis_eval/version"

Gem::Specification.new do |spec|
  spec.name          = "redis_eval"
  spec.version       = RedisEval::VERSION
  spec.authors       = ["i2bskn"]
  spec.email         = ["iiboshi@craftake.co.jp"]

  spec.summary       = "Evaluate Lua scripts with Redis."
  spec.description   = "Evaluate Lua scripts with Redis."
  spec.homepage      = "https://github.com/i2bskn/redis_eval"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.6"

  spec.add_dependency "redis"

  spec.add_development_dependency "bundler", ">= 2.1.0"
  spec.add_development_dependency "pry", "~> 0.14.0"
  spec.add_development_dependency "rake", "~> 13.0.0"
  spec.add_development_dependency "rspec", "~> 3.10.0"
  spec.add_development_dependency "rubocop", "~> 1.11.0"
end
