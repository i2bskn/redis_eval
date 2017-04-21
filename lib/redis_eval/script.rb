module RedisEval
  class Script
    attr_accessor :script_set
    attr_reader :script, :sha

    def self.build_from_script_set(script, script_set, with_load: true)
      script = new(script, with_load: with_load)
      script.script_set = script_set
      script
    end

    def initialize(script, with_load: true)
      @script = script
      @sha    = Digest::SHA1.hexdigest(script)
      self.load if with_load
    end

    def load
      redis.script(:load, script)
    end

    def exist?
      redis.script(:exists, sha)
    end

    def execute(keys = [], argv = [])
      redis.evalsha(sha, Array(keys), Array(argv))
    rescue Redis::CommandError => e
      if e.message =~ /NOSCRIPT/
        redis.eval(script, Array(keys), Array(argv))
      else
        raise
      end
    end

    def redis
      case
      when instance_variable_defined?(:@redis)
        @redis
      when !script_set.nil?
        script_set.redis
      else
        Redis.current
      end
    end

    def redis=(conn)
      @redis = conn
    end
  end
end
