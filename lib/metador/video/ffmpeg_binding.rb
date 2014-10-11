require 'shellwords'

module Metador
  module Video
    class FfmpegBinding
      def meta(path)
        cmd = "ffprobe -v quiet -print_format json -show_format -show_streams #{Shellwords.escape(path)}"
        result = JSON.parse(`#{cmd}`, symbolize_names: true)
        result.empty? ? nil : Metador::Video::Movie.new(result)
      end

      def screenshot(src_path, dest_path, time, w, h)
        cmd =
            "ffmpeg -y -ss #{time} -i #{Shellwords.escape(src_path)} " +
            " -s #{w}x#{h} " +
            " -v warning" +
            ' -vf select="eq(pict_type\,I)" ' +
            '-vframes 1 ' +
            '-f image2 ' +
            Shellwords.escape(dest_path)
        @result = `#{cmd}`
      end
    end
  end
end