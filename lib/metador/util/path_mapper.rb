module Metador
  module Util
    class PathMapper
      attr_reader :config

      class MapperException < Exception
      end

      def initialize(config)
        @config = config
        @mappings = config.path_mappings || {}
      end

      def map_src(path, exists: true)
        rs = map_path(path)
        if exists && !File.exist?(rs)
          raise MapperException.new("No existing source file found: #{rs}")
        end
        rs
      end

      def map_dest(path, clean: false)
        rd = map_path(path)
        if clean && File.exists?(ds)
          File.unlink(ds)
        end
        rd
      end

      private

      def map_path(path)
        @mappings.each { |m|
          k = m["from"]
          if path.start_with? k
            return m["to"] + path[k.size..-1]
          end
        }
        path
      end


    end
  end
end