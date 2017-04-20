module RedisEval
  class ScriptSet
    attr_reader :src_path

    SCRIPT_SUFFIX = ".lua"

    def initialize(path)
      @src_path = pathname(path)
    end

    def load(name)
      loaded_scripts[name_str] ||= RedisEval::Script.new(script_path(name), true)
    end

    def load_all_script
      src_path.children(false).each do |path|
        name = path.basename(SCRIPT_SUFFIX).to_s
        loaded_scripts[name] ||= RedisEval::Script.new(path.read, true)
      end
    end

    private

      def pathname(path)
        path.is_a?(Pathname) ? path : Pathname.new(path)
      end

      def loaded_scripts
        @loaded_scripts ||= {}
      end

      def script_path(name)
        src_path.join(name.to_s).sub_ext(SCRIPT_SUFFIX)
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
