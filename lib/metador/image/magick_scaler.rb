require 'mini_magick'

#Most reliable scaler using ImageMagick for wide range of files and documents
module Metador
  module Image
    class MagickScaler

      def accepts_mime?(mime, ext)
        true #fallback scaler, takes anything
      end

      def scale(infile:nil, outfile:nil, ext:nil, size: 100)
        MiniMagick::Tool::Convert.new do |conv|
          dim = "#{size}x#{size}"
          conv.thumbnail dim
          conv.background "white"
          conv.define "jpeg:size=#{dim}"
          conv.alpha "remove"
          conv.alpha "off"
          conv.auto_orient
          conv << infile + "[0]"
          conv << outfile
        end
      end
    end
  end
end