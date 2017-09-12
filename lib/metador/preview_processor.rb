require 'mini_magick'

module Metador
  class PreviewProcessor

    pattr_initialize :config, :preview_processors

    def self.build(config)
      new(
          config,
          [
              Metador::AudioVideo::PreviewProcessor.build(config),
              Metador::Image::PreviewProcessor.build(config)
          ]
      )
    end

    def process(data)
      preview_processors.each do |p|
        begin
          if p.accepts?(data) and p.process(data)
            break
          end
        rescue => e
          puts "Preview processor #{p.class} failed with #{data[:source_file]}: #{e} #{e.backtrace}"
        end
      end
    end

    def accepts?(data)
      data[:query][:preview] || data[:query][:meta]
    end
  end
end