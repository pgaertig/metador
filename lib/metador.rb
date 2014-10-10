require "metador/version"
require "bunny"
require "json"
require 'attr_extras'

module Metador

  autoload :FileResolver, 'metador/file_resolver'
  autoload :MimeExtractor, 'metador/misc/mime_extractor'
  autoload :QueryProcessor, 'metador/query_processor'
  autoload :PreviewProcessor, 'metador/preview_processor'
  autoload :MetadorProcessor, 'metador/metador_processor'
  autoload :MimeProcessor, 'metador/mime_processor'

  module Image
    autoload :GdkScaler, 'metador/image/gdk_scaler'
    autoload :VipsScaler, 'metador/image/vips_scaler'
    autoload :MagickScaler, 'metador/image/magick_scaler'
    autoload :PreviewProcessor, 'metador/image/preview_processor'
  end

  module Misc
    autoload :PdfConverter, 'metador/misc/pdf_converter'
    autoload :MimeExtractor, 'metador/misc/mime_extractor'
  end

  module Video
    autoload :PreviewProcessor, 'metador/video/preview_processor'
  end

  class MessageHandler

    attr_reader :config

    def initialize(config)
      @config = config
      @metador_processor = Metador::MetadorProcessor.new(config)
    end

    def consume!(raw_data)
      JSON.unparse(
          @metador_processor.process(JSON.parse(raw_data, symbolize_names: true))
      )
    end

    def amqp_worker
      conn = Bunny.new(config.broker_uri)
      conn.start

      p "Metador: Connected"

      ch = conn.create_channel
      q  = ch.queue(config.broker_queue, durable: true)
      x  = ch.default_exchange
      ch.prefetch 1

      q.subscribe(block: true, ack: true) do |delivery_info, metadata, payload|
        begin
          puts "Received #{payload}"
          result = consume!(payload)
          #x.publish(JSON.unparse(result), :routing_key => "")
          puts "Reponded: #{result}"
          ch.ack(delivery_info.delivery_tag)
        rescue
          #sleep 1
          #ch.nack(delivery_info.delivery_tag, true)
          p "#{$!} #{$!.backtrace}"
        end
      end
      conn.close
    end
  end
end