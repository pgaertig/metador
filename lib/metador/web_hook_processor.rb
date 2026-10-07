require 'faraday'

module Metador
  class WebHookProcessor

    pattr_initialize :config

    def self.build(config)
      new(config)
    end

    def process(data)
      f = Faraday.new(data[:webhook]) do |faraday|
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
      f.post do |req|
        req.url data[:webhook]
        req.headers['Content-Type'] = 'application/json'
        req.body = payload(data).to_json
      end
    end

    # Full EXIF only on request (query.exif)
    def payload(data)
      data.dig(:query, :exif) ? data : data.except(:exif)
    end

    def accepts?(data)
      data[:webhook]
    end
  end
end
