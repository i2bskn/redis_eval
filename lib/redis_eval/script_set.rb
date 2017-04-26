module RedisEval
  class ScriptSet
    attr_reader :path

    SCRIPT_SUFFIX = ".lua"

    def initialize(target_path, conn = nil)
      @path  = pathname(target_path)
      @redis = conn
    end

    def load(name)
      source = ERB.new(script_path(name).read).result
      loaded_scripts[name.to_s] ||= RedisEval::Script.build_from_parent(source, self)
    end

    def load_all
      path.children(false).each { |child| self.load(child.basename(SCRIPT_SUFFIX).to_s) }
      true
    end

    def redis
      @redis || Redis.current
    end

    def redis=(conn)
      @redis = conn
    end

    private

      def pathname(path)
        path.is_a?(Pathname) ? path : Pathname.new(path)
      end

      def loaded_scripts
        @loaded_scripts ||= {}
      end

      def script_path(name)
        path.join(name.to_s).sub_ext(SCRIPT_SUFFIX)
      end

      def method_missing(name, *args, &block)
        super unless respond_to?(name)

        self.load(name)
        define_singleton_method(name) { |*a, &b| loaded_scripts[name.to_s] }
        send(name, *args, &block)
      end

      def respond_to_missing?(name, include_private = false)
        loaded_scripts.has_key?(name.to_s) || script_path(name).exist? || super
      end
  end
end
