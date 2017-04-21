module RedisEval
  class Script
    attr_accessor :parent
    attr_reader :source, :sha

    def self.build_from_parent(src, parent, with_load: true)
      script        = new(src, with_load: with_load)
      script.parent = parent
      script
    end

    def initialize(src, with_load: true)
      @source = src
      @sha    = Digest::SHA1.hexdigest(@source)
      @redis  = nil
      self.load if with_load
    end

    def load
      redis.script(:load, source)
    end

    def exist?
      redis.script(:exists, sha)
    end

    def execute(keys = [], argv = [])
      redis.evalsha(sha, Array(keys), Array(argv))
    rescue Redis::CommandError => e
      if e.message =~ /NOSCRIPT/
        redis.eval(source, Array(keys), Array(argv))
      else
        raise
      end
    end

    def redis
      return @redis if @redis
      parent ? parent.redis : Redis.current
    end

    def redis=(conn)
      @redis = conn
    end
  end
end
