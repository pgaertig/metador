require 'streamio-ffmpeg'

module Metador
  module Video
    class PreviewProcessor

      pattr_initialize :config, :file_resolver

      def self.build(config)
        new(
            config,
            Metador::FileResolver.new(config)
        )
      end

      def accepts?(data)
        data[:mime] =~ /^video\//
      end

      def process(data)
        movie = FFMPEG::Movie.new(file_resolver.resolve_src(data[:source_file]))

        return unless movie.valid?

        query_preview = data[:query][:preview]

        #Calculate number of screenshots
        d = movie.duration
        n = d > 30 ? 3 : 1
        n += ([3600, d].min / 300).to_i # each 5 minutes adds one more frame

        #Calculate screenshot size with proper aspect ratio
        s = query_preview[:size] || 160
        w = movie.width
        h = movie.height
        tw = [s, w * [s/w,s/h].min].min.to_i
        th = [s, h * [s/w,s/h].min].min.to_i

        files = []

        (1..n).each {|no|
          time = ((no - 0.5) * d / n).to_i
          files << process_frame(movie, time, tw, th, query_preview[:destination_file], no)
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

      def process_frame(movie, time, w, h, dest, no)
        dest = "#{dest}-%02d.jpg" % no
        dest_path = file_resolver.resolve_dest(dest)

        #TODO make it faster https://trac.ffmpeg.org/wiki/Seeking%20with%20FFmpeg https://github.com/streamio/streamio-ffmpeg/pull/40
        movie.screenshot(dest_path,
                         seek_time: time,
                         resolution: "#{w}x#{h}",
                         custom: '-vf select="eq(pict_type\,I)"')
        dest if File.exists? dest_path
      end
    end
  end
end
