module Metador
  class MimeProcessor

    pattr_initialize :config, :mime_extractor, :path_mapper

    def self.build(config)
      new(
          config,
          Metador::Util::MimeExtractor.new,
          Metador::Util::PathMapper.new(config)
      )
    end


    def process(data)
      data[:mime] = mime_extractor.find_mime(path_mapper.map_src(data[:source_file]))
    end

    def accepts?(data)
      true #Always detect source file mime
    end
  end
end