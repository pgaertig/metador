require 'open3'
require 'tempfile'

# Camera RAW previews from the JPEG embedded by the camera. Faster than full
# demosaicing and works for formats LibRaw can't decode (e.g. Nikon HE/HE* NEF).
module Metador
  module Image
    class RawEmbeddedScaler

      RAW_EXTS = %w[nef nrw cr2 cr3 crw arw srf sr2 raf orf rw2 pef dng srw x3f 3fr iiq].freeze
      EMBEDDED_TAGS = %w[JpgFromRaw PreviewImage OtherImage].freeze
      MIN_EMBEDDED_BYTES = 50_000 # skip tiny EXIF thumbnails, let MagickScaler decode instead

      def initialize(jpeg_scaler = VipsScaler.new)
        @jpeg_scaler = jpeg_scaler
      end

      def accepts_mime?(mime, ext = nil)
        RAW_EXTS.include?(ext.to_s)
      end

      def scale(infile:nil, outfile:nil, mime:nil, ext:nil, size: 100)
        Tempfile.create(['raw-embedded', '.jpg']) do |tmp|
          tmp.binmode
          return unless extract_largest(infile, tmp)
          copy_orientation(infile, tmp.path)
          @jpeg_scaler.scale(infile: tmp.path, outfile: outfile, mime: VipsScaler::JPEG_MIME, size: size)
        end
      end

      private

      def extract_largest(infile, tmp)
        EMBEDDED_TAGS.each do |tag|
          data, status = Open3.capture2('exiftool', '-b', "-#{tag}", infile, binmode: true)
          next unless status.success? && data.bytesize >= MIN_EMBEDDED_BYTES
          tmp.write(data)
          tmp.flush
          return true
        end
        false
      end

      # Embedded JPEG usually has no EXIF, so orientation lives only in the RAW container
      def copy_orientation(infile, jpg)
        Open3.capture2e('exiftool', '-q', '-overwrite_original',
                        '-tagsFromFile', infile, '-Orientation', jpg)
      end
    end
  end
end
