require 'gdk_pixbuf2'

module Metador
  module Image
    class GdkScaler
      def scale(infile:nil, outfile:nil, ext: 'jpg', size: 100)
        resize_pixbuf infile, outfile, size, ext =~ /jpg/ ? 'jpeg' : ext
      end

      def pixbuf_reorient src
        case src.get_option 'orientation'
          when "2" then
            src.flip(true)
          when "3" then
            src.rotate(Gdk::Pixbuf::ROTATE_UPSIDEDOWN)
          when "4" then
            src.rotate(Gdk::Pixbuf::ROTATE_UPSIDEDOWN).flip(true)
          when "5" then
            src.rotate(Gdk::Pixbuf::ROTATE_CLOCKWISE).flip(true)
          when "6" then
            src.rotate Gdk::Pixbuf::ROTATE_CLOCKWISE
          when "7" then
            src.rotate(Gdk::Pixbuf::ROTATE_COUNTERCLOCKWISE).flip(true)
          when "8" then
            src.rotate(Gdk::Pixbuf::ROTATE_COUNTERCLOCKWISE)
          else
            src
        end
      rescue
        src
      end

      private

      def resize_pixbuf infile, outfile, size, filetype
        pixbuf = Gdk::Pixbuf.new(file:infile, width:size, height: size)
        pixbuf = pixbuf_reorient pixbuf
        pixbuf.save(outfile, filetype)
        return pixbuf.width, pixbuf.height
      end
    end
  end
end

