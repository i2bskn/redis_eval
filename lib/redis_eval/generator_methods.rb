module RedisEval
  module GeneratorMethods
    def build(name)
      path = case name
        when Pathname
          name
        when String, Symbol
          name =~ /\.lua$/ ? pathname(name.to_s) : script_path(name)
        else
          raise ArgumentError
        end

      RedisEval::Script.build_from_path(path)
    end

    private
      def pathname(path)
        path.is_a?(String) ? Pathname.new(path) : path
      end

      def script_cache
        @script_cache ||= {}
      end

      def script_path(name)
        RedisEval.config.script_paths.each {|path|
          if (script = pathname(path).join("#{name}.lua")).exist?
            return script
          end
        }
        nil
      end

      def method_missing(name, *args, &block)
        super unless respond_to?(name)

        define_singleton_method(name) do |*a, &b|
          script_cache[name.to_s] ||= build(name)
        end

        send(name, *args, &block)
      end

      def respond_to_missing?(name, include_private = false)
        !!script_path(name)
      end
  end

  extend GeneratorMethods
end
