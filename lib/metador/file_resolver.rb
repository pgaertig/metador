module Metador
  class FileResolver
    attr_reader :config

    class ResolverException < Exception
    end

    def initialize(config)
      @config = config
    end

    def resolve_src(path, exists: false)
      rs = File.join(config.src_dir, path)
      if exists && !File.exist?(rs)
        raise ResolverException.new("No existing source file found: #{rs}")
      end
      rs
    end

    def resolve_dest(path, clean: false)
      rd = File.join(config.dest_dir, path)
      if clean && File.exists?(ds)
        File.unlink(ds)
      end
      rd
    end


  end
end