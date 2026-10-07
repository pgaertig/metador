module Metador
  class MimeProcessor

    pattr_initialize :config, :exif_extractor, :path_mapper

    def self.build(config)
      new(
          config,
          Metador::Util::ExifExtractor.new,
          Metador::Util::PathMapper.new(config)
      )
    end


    def process(data)
      exif = exif_extractor.extract(path_mapper.map_src(data[:source_file]))
      unless exif.empty?
        data[:exif] = exif
        data[:mime] = exif['MIMEType'] if exif['MIMEType']
        data[:type] = exif['FileTypeExtension'] if exif['FileTypeExtension'].upcase
      end
      data
    end

    # Caller already knows the type
    def accepts?(data)
      !data[:mime]
    end
  end
end