module Metador
  class MimeProcessor

    pattr_initialize :config, :mime_extractor, :file_resolver

    def self.build(config)
      new(
          config,
          Metador::Misc::MimeExtractor.new,
          Metador::FileResolver.new(config)
      )
    end


    def process(data)
      data[:mime] = mime_extractor.find_mime(file_resolver.resolve_src(data[:source_file]))
    end

    def accepts?(data)
      true #Always detect source file mime
    end
  end
end