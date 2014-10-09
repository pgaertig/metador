module Metador
  class MetadorProcessor < BaseProcessor

    attr_accessor :query_processor, :mime_extractor

    def initialize(config)
      super(config)
      @file_resolver = Metador::FileResolver.new(config)

      @mime_processor = Metador::MimeProcessor.new(config)
      @query_processor = Metador::QueryProcessor.new(config)
    end

    def process(data)
      @mime_processor.process(data, file_resolver: @file_resolver)
      @query_processor.process(data,
                               file_resolver: @file_resolver,
                               preview_processor: PreviewProcessor.new(@config))
      data
    end


  end
end