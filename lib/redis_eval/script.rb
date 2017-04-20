module RedisEval
  class Script
    attr_reader :script, :sha

    class << self
      def flush
        redis.script(:flush)
      end

      def redis
        Redis.current
      end
    end

    def initialize(script, with_load = false)
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
      self.class.redis
    end
  end
end
