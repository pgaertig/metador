require "metador/version"
require "bunny"
require "json"
require "thread"
require 'attr_extras'

module Metador

  autoload :PathMapper, 'metador/path_mapper'
  autoload :QueryProcessor, 'metador/query_processor'
  autoload :PreviewProcessor, 'metador/preview_processor'
  autoload :MetadorProcessor, 'metador/metador_processor'
  autoload :MimeProcessor, 'metador/mime_processor'
  autoload :WebHookProcessor, 'metador/web_hook_processor'

  module Image
    autoload :GdkScaler, 'metador/image/gdk_scaler'
    autoload :VipsScaler, 'metador/image/vips_scaler'
    autoload :MagickScaler, 'metador/image/magick_scaler'
    autoload :PreviewProcessor, 'metador/image/preview_processor'
  end

  module Util
    autoload :PdfConverter, 'metador/util/pdf_converter'
    autoload :MimeExtractor, 'metador/util/mime_extractor'
    autoload :PathMapper, 'metador/util/path_mapper'
  end

  module AudioVideo
    autoload :FfmpegBinding, 'metador/audio_video/ffmpeg_binding'
    autoload :PreviewProcessor, 'metador/audio_video/preview_processor'
    autoload :Meta, 'metador/audio_video/meta'
  end

  class MessageHandler

    attr_reader :config

    def initialize(config)
      @config = config
      @metador_processor = Metador::MetadorProcessor.build(config)
    end

    def consume!(raw_data)
      JSON.unparse(
          @metador_processor.process(JSON.parse(raw_data, symbolize_names: true))
      )
    end

    def amqp_worker(worker_lifetime = 100)
      pid = Process.pid
      puts "Metador[#{pid}]: Starting worker with lifetime limit #{worker_lifetime}"

      conn = Bunny.new(config.broker_uri)
      conn.start

      puts "Metador[#{pid}]: RabbitMQ connected"

      ch = conn.create_channel
      q  = ch.queue(config.broker_queue, durable: true)
      x  = ch.default_exchange
      ch.prefetch 1

      runs = worker_lifetime
      finish = Queue.new

      consumer = nil
      consumer = q.subscribe(manual_ack: true) do |delivery_info, metadata, payload|
        begin
          puts "Metador[#{pid}]: Received #{payload}"
          result = consume!(payload)
          #x.publish(JSON.unparse(result), :routing_key => "")
          puts "Metador[#{pid}]: Reponded: #{result}"
          ch.ack(delivery_info.delivery_tag)
        rescue => e
          #sleep 1
          ch.nack(delivery_info.delivery_tag, true)
          puts "Metador[#{pid}]: #{$e} #{$e.backtrace}. Continuing next file."
        end
        runs -= 1
        if runs <= 0
          puts "Metador[#{pid}]: Worker lifetime reached."
          consumer.cancel if consumer
          finish.enq true
        end
      end

      Signal.trap("TERM") do
        conn.close if conn
      end

      Signal.trap("INT") do
        conn.close if conn
      end

      finish.deq
      conn.close
    end

    def amqp_multiple_workers(worker_count, worker_lifetime)

      worker_pids = []
      puts "Metador[main]: Starting #{worker_count} worker(s) with lifetime #{worker_lifetime} runs each."

      while worker_pids.size < worker_count
        4.times { GC.start }
        worker_pids << Process.fork do
          sleep 1
          amqp_worker(worker_lifetime)
        end

        if worker_pids.size >= worker_count
          # Waits for any child to stop and then the outer loop will spawn new one
          pid = Process.wait
          puts "Metador[main]: Worker #{pid} finished"
          worker_pids.delete pid
        end
      end

    end
  end
end
