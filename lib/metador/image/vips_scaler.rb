require 'vips'

# Fastest image scaler which uses compression properties of jpeg to extract smaller
# images directly by evaluating downsampled blocks. See: http://en.wikipedia.org/wiki/JPEG#Block_splitting
module Metador
  module Image
    class VipsScaler

      def accepts_mime?(mime)
        mime =~ /^image\/(jpeg|tiff|png)/
      end

      def scale(infile:nil, outfile:nil, ext:nil, size: 100)
        resize_vips infile, outfile, size, ext
      end

      def resize_vips infile, outfile, size, filetype
        mask = [
            [-1, -1,  -1],
            [-1,  32, -1,],
            [-1, -1,  -1]
        ]
        m = VIPS::Mask.new mask, 24, 0

        a = vips_load_file infile, filetype

        d = [a.x_size, a.y_size].max
        shrink = d / size.to_f

        if filetype == "jpg"
          if shrink >= 8
            load_shrink = 8
          elsif shrink >= 4
            load_shrink = 4
          elsif shrink >= 2
            load_shrink = 2
          end

          a = vips_load_file infile, filetype, load_shrink

          d = [a.x_size, a.y_size].max
          shrink = d / size.to_f
        end

        a = vips_reorient a

        ishrink = shrink.to_i

        id = (d / ishrink).to_i
        rscale = size.to_f / id

        a = a.shrink(ishrink)
        a = a.tile_cache(a.x_size, 1, 30)
        a = a.affinei_resize(:nohalo, rscale)
        a = a.conv(m)

        jpeg = VIPS::JPEGWriter.new(a, {:quality => 75})
        jpeg.remove_icc
        jpeg.remove_exif

        outfile ? jpeg.write(outfile) : jpeg.to_memory
      end

      def vips_reorient src
        begin
          orient = src.get("exif-ifd0-Orientation") || "0"
          orient = orient[0]
          case orient
            when "2" then
              src.fliphor
            when "3" then
              src.rot180
            when "4" then
              src.rot180.fliphor
            when "5" then
              src.rot90.fliphor
            when "6" then
              src.rot90
            when "7" then
              src.rot270.fliphor
            when "8" then
              src.rot270
            else
              src
          end
        rescue VIPS::Error
          src
        end
      end

      def vips_load_file(infile, filetype = "jpg", shrink=1)
        if filetype == "jpg"
          VIPS::Image.jpeg infile,
                           :shrink_factor => shrink,
                           :sequential => true
        elsif filetype == "tif"
          VIPS::Image.tiff infile,
                           :sequential => true
        elsif filetype == "png"
          VIPS::Image.png infile,
                          :sequential => true
        else
          VIPS::Image.new infile
        end
      end



    end
  end
end
