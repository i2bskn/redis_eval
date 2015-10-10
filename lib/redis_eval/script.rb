module RedisEval
  class Script
    attr_reader :name, :script, :sha

    class << self
      # @param path [Pathname]
      # @return [RedisEval::Script]
      def build_from_path(path)
        name = path.basename(".*").to_s
        script = File.read(path)
        new(name, script)
      end

      def flush
        redis.script(:flush)
      end

      def kill
        redis.script(:kill)
      end

      def load(script)
        redis.script(:load, script)
      end

      def redis
        RedisEval.config.redis
      end
    end

    def initialize(name, script)
      @name = name
      @script = script
      @sha = Digest::SHA1.hexdigest(script)
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

    def exist?
      redis.script(:exists, sha)
    end

    def redis
      self.class.redis
    end
  end
end
