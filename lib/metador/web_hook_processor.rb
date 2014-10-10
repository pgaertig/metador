require 'faraday'

module Metador
  class WebHookProcessor
    def process(data, options = {})
      f = Faraday.new(data[:callback]) do |faraday|
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
      f.post do |req|
        req.url data[:callback]
        req.headers['Content-Type'] = 'application/json'
        req.body = data.to_json
      end
    end

    def accepts?(data)
      data[:callback]
    end
  end
end
