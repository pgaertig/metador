module Metador
  module Video
    class PreviewProcessor

      pattr_initialize :config, :path_mapper, :ffmpeg_binding

      def self.build(config)
        new(
            config,
            Metador::Util::PathMapper.new(config),
            Metador::Video::FfmpegBinding.new
        )
      end

      def accepts?(data)
        data[:mime] =~ /^video\//
      end

      def process(data)
        src_file = path_mapper.map_src(data[:source_file])
        mmeta = ffmpeg_binding.meta(src_file)
        vstream = mmeta.first_video_stream
        return unless vstream

        query_preview = data[:query][:preview]

        #Calculate number of screenshots
        d = vstream.duration
        n = d > 30 ? 3 : 1
        n += ([3600, d].min / 300).to_i # each 5 minutes adds one more frame

        #Calculate screenshot size with proper aspect ratio
        s = query_preview[:size] || 160
        w = vstream.width
        h = vstream.height
        tw = [w, s, w * s / h].min.to_i
        th = [h, s, h * s / w].min.to_i

        files = []

        (1..n).each {|no|
          time = ((no - 0.5) * d / n).to_i
          files << process_frame(src_file, time, tw, th, query_preview[:destination_file], no)
        }

        unless files.empty?
          data[:preview] = {
              width: tw,
              height: th,
              destination_file: files
          }
        end
        data
      end

      def process_frame(src, time, w, h, dest, no)
        dest = "#{dest}-%02d.jpg" % no
        dest_path = path_mapper.map_dest(dest)

        ffmpeg_binding.screenshot(src, dest_path, time, w, h)

        dest if File.exists? dest_path
      end
    end
  end
end
