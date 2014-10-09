module Metador
  class MimeProcessor < BaseProcessor

    MIME_EXTRACTOR = Metador::Misc::MimeExtractor.new

    def process(data, file_resolver: )
      data[:mime] = MIME_EXTRACTOR.find_mime(file_resolver.resolve_src(data[:source_file]))
    end
  end
end