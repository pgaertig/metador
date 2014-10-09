module Metador
  module Image
    class MagickScaler
      def scale(infile:nil, outfile:nil, ext:nil, size: 100)
        MiniMagick::Tool::Convert.new do |conv|
          conv.thumbnail "x#{size}"
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