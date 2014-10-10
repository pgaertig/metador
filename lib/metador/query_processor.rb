module Metador
  class QueryProcessor

    pattr_initialize :config, :subprocessors

    def self.build(config)
      new(
          config,
          [
              MimeProcessor.build(config),
              PreviewProcessor.build(config)
              #MetaProcessor.build(config),
              #WebHookProcessor.build(config)
          ]
      )
    end

    def process(data)
      subprocessors.each do |p|
        p.process(data) if p.accepts?(data)
      end
      data
    end

    def accepts?(data)
      data[:query]
    end
  end
end