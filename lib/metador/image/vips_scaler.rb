require 'vips'

# Fastest image scaler which uses compression properties of jpeg to extract smaller
# images directly by evaluating downsampled blocks. See: http://en.wikipedia.org/wiki/JPEG#Block_splitting
module Metador
  module Image
    class VipsScaler

      JPEG_MIME = "image/jpeg"

      def accepts_mime?(mime, ext=nil)
        #Unfortunately libmagic recognizes some camera RAW files as TIFFs and Vips can't process them properly
        mime =~ /^image\/(jpeg|png)/ || (mime == 'image/tiff' && ext && ext =~ /^tiff?$/)
      end

      def scale(infile:nil, outfile:nil, mime:nil, ext:nil, size: 100, upscale:false)
        resize_vips infile, outfile, size, mime, upscale
      end

      def resize_vips infile, outfile, size, mime, upscale
        mask = [
            [-1, -1,  -1],
            [-1,  32, -1,],
            [-1, -1,  -1]
        ]
        m = Vips::Image.new_from_array(mask, 24)

        a = vips_load_file infile, mime

        d = [a.width, a.height].max
        scale = d / size.to_f

        if mime == JPEG_MIME
          if scale >= 8
            load_scale = 8
          elsif scale >= 4
            load_scale = 4
          elsif scale >= 2
            load_scale = 2
          end

          if load_scale
            #p "JPEG shrink optimization: #{load_scale}"
            a = vips_load_file infile, mime, load_scale

            d = [a.width, a.height].max
            scale = d / size.to_f
          end
        end


#        ishrink = shrink.to_i

#        id = (d / ishrink).to_i
#        rscale = size.to_f / id

#        a = a.shrink(ishrink,ishrink)
        #a = a.tile_cache(a.width, 1, 30)
        #a = a.affinei_resize(:nohalo, rscale)
        if scale > 1 || upscale
          a = a.resize(1 / scale)
          a = a.conv(m)
        end

        a = vips_reorient a

#        jpeg = Vips::JPEGWriter.new(a, {:quality => 75})
#        jpeg.remove_icc
#        jpeg.remove_exif

        if outfile
          a.write_to_file(outfile, strip: true, :Q => 75)
          outfile
        else
          a.write_to_buffer(".jpg", strip: true, :Q => 75)
        end
      end

      def vips_reorient src
        begin
          orient = src.get("exif-Orientation") || src.get("exif-ifd0-Orientation") || "X"
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
        rescue Vips::Error
          src
        end
      end

      def vips_load_file(infile, mime, shrink_level=1)
        if mime == JPEG_MIME
          Vips::Image.new_from_file infile, access: :sequential,
                           shrink: shrink_level, autorotate: true
        else
          Vips::Image.new_from_file infile, access: :sequential
        end
      end



    end
  end
end
