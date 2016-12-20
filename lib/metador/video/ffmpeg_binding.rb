require 'shellwords'

module Metador
  module Video
    class FfmpegBinding

      def initialize
        begin
          /^ffmpeg version (?<version>(?<major>\d+)\.(?<minor>\d+)[^\s]+)\s/ =~ `ffmpeg -version`

          unless major&.to_i >= 3
            raise "ffmpeg =>3.0 is required, detected: #{version}"
          end
        rescue Errno::ENOENT => ioe
          raise "No ffmpeg executable found in run path: " + ioe.to_s
        end
      end

      def meta(path)
        cmd = "ffprobe -v quiet -print_format json -show_format -show_streams #{Shellwords.escape(path)}"
        result = JSON.parse(`#{cmd}`, symbolize_names: true)
        result.empty? ? nil : Metador::Video::Movie.new(result)
      end

      def screenshot(src_path, dest_path, time, w, h)
        cmd =
            "ffmpeg -y -ss #{time} -i #{Shellwords.escape(src_path)} " +
            " -v warning" +
            ' -vf select="eq(pict_type\,I)" ' +
            %Q{ -vf scale="iw*min(1\\,if(gt(iw\\,ih)\\,#{w}/iw\\,(#{h}*sar)/ih)):(floor((ow/dar)/2))*2" } +
            ' -sws_flags fast_bilinear ' +
            ' -q:v 2 -vframes 1 ' +
            ' -f image2 ' +
            Shellwords.escape(dest_path)
        puts "+ #{cmd}"
        @result = `#{cmd}`
      end
    end
  end
end