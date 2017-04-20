module RedisEval
  class Configuration
    module Accessible
      def configure(options = {}, &block)
        config.merge!(options) unless options.empty?
        config.configure(&block) if block_given?
      end

      def config
        @_config ||= Configuration.new
      end
    end

    VALID_OPTIONS = [
      :redis_options,
      :script_paths,
    ].freeze

    attr_accessor(*VALID_OPTIONS)

    def initialize
      reset
    end

    def redis(cache_disable: false)
      if cache_disable
        @_redis = generate_redis_connection!
      else
        @_redis ||= generate_redis_connection!
      end
    end

    def configure
      yield self
    end

    def merge(params)
      self.dup.merge!(params)
    end

    def merge!(params)
      params.keys.each {|key| self.send("#{key}=", params[key]) }
      self
    end

    def reset
      self.redis_options = nil
      self.script_paths = []
    end

    private
      def generate_redis_connection!
        redis_options ? Redis.new(**redis_options) : Redis.current
      end
  end

  extend Configuration::Accessible
end
