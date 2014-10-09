require 'mini_magick'

##
## Hq: convert -density 300 $f[0] -quality 100 -resize 960x +adjoin $f-%02da.png

module Metador
  module Misc
    class PdfConverter
      def scale(infile:nil, outfile:nil, ext: "png", size: 100)
        file = outfile + ".png"
        MiniMagick::Tool::Convert.new do |c|
          c.thumbnail "x#{size}"
          c.background "white"
          c.alpha "remove"
          c.alpha "off"
          c << infile + "[0]"
          c << outfile + ".png"
        end
        outfile
      end
    end
  end
end