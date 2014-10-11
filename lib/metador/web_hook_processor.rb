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
        req.body = data.to_json
      end
    end

    def accepts?(data)
      data[:webhook]
    end
  end
end
