require 'exiftool'
require 'json'
require 'shellwords'

module Metador
  module Util
    class ExifExtractor
      def extract(path)
        begin
          escaped_path = Shellwords.escape(path)
          cmd = "exiftool -j -coordFormat \"%.8f\" #{escaped_path} 2> /dev/null"
          json = `#{cmd}`.chomp
          raise "exiftool not installed" if json == ''
          return JSON.parse(json).first
        rescue => e
          puts "Error extracting EXIF data of #{path}: #{e.message}"
        end
        {}
      end

    end
  end
end