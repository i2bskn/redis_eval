module RedisEval
  class Script
    attr_accessor :parent
    attr_reader :source, :sha
    attr_writer :redis

    def self.build_from_parent(src, parent, with_load: true)
      script = new(src, with_load: false)
      script.parent = parent
      script.load if with_load
      script
    end

    def initialize(src, with_load: true)
      @source = src
      @sha    = Digest::SHA1.hexdigest(@source)
      @redis  = nil
      self.load if with_load
    end

    def load
      redis_without_namespace.script(:load, source)
    end

    def exist?
      redis_without_namespace.script(:exists, sha)
    end

    def execute(keys = [], argv = [])
      redis.evalsha(sha, Array(keys), Array(argv))
    rescue Redis::CommandError => e
      raise unless e.message =~ /NOSCRIPT/

      redis.eval(source, Array(keys), Array(argv))
    end

    def redis
      return @redis if instance_variable_defined?(:@redis)

      parent&.redis || Redis.current
    end

    private

      def redis_without_namespace
        defined?(Redis::Namespace) && redis.is_a?(Redis::Namespace) ? redis.redis : redis
      end
  end
end
