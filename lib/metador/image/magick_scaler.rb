require 'mini_magick'

#Most reliable scaler using ImageMagick for wide range of files and documents
module Metador
  module Image
    class MagickScaler

      def accepts_mime?(mime)
        true #fallback scaler, takes anything
      end

      def scale(infile:nil, outfile:nil, ext:nil, size: 100)
        MiniMagick::Tool::Convert.new do |conv|
          conv.thumbnail "#{size}x#{size}"
          conv.background "white"
          conv.alpha "remove"
          conv.alpha "off"
          conv << infile + "[0]"
          conv << outfile
        end
      end
    end
  end
end