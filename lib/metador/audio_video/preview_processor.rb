module Metador
  module AudioVideo
    class PreviewProcessor

      pattr_initialize :config, :path_mapper, :ffmpeg_binding

      def self.build(config)
        new(
            config,
            Metador::Util::PathMapper.new(config),
            Metador::AudioVideo::FfmpegBinding.new
        )
      end

      def accepts?(data)
        data[:mime] =~ /^(video|audio)\// or
        %w(application/mxf model/vnd.mts application/mp4 application/octet-stream).include?(data[:mime])
      end

      def process(data)
        src_file = path_mapper.map_src(data[:source_file])
        meta = ffmpeg_binding.meta(src_file)
        return unless meta&.has_video? || meta&.has_audio?

        #Attach meta if requested
        if data[:query][:meta]
          data[:meta] = meta.meta_map
        end

        query_preview = data[:query][:preview]

        if query_preview && meta&.has_video?

          #Calculate number of screenshots
          d = meta.duration
          n = d > 30 ? 3 : 1
          n += ([3600, d].min / 300).to_i # each 5 minutes adds one more frame

          #Calculate screenshot size with proper aspect ratio
          s = query_preview[:size] || 160

          files = []

          time = Benchmark.realtime do
            (1..n).each {|no|
              time = ((no - 0.5) * d / n).to_i
              files << process_frame(src_file, time, s, s, query_preview[:destination_file], no)
            }
          end

          unless files.empty?
            dest_path = files.first
            info = MiniMagick::Image.new(path_mapper.map_dest(dest_path))
            data[:preview] = {
                width: info['width'],
                height: info['height'],
                destination_file: files,
                _debug: {scaler: self.class.name, process_time: time}
            }
          end
        end

        data
      end

      def process_frame(src, time, w, h, dest, no)
        dest = "#{dest}-%02d.jpg" % no
        dest_path = path_mapper.map_dest(dest)

        ffmpeg_binding.screenshot(src, dest_path, time, w, h)

        dest if File.exist? dest_path
      end
    end
  end
end
