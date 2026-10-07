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
      JPEG_SOI = "\xFF\xD8".b
      # exiftool -j prints Orientation as text, VipsScaler expects the EXIF number
      ORIENTATIONS = {
        'Horizontal (normal)' => 1, 'Mirror horizontal' => 2, 'Rotate 180' => 3,
        'Mirror vertical' => 4, 'Mirror horizontal and rotate 270 CW' => 5,
        'Rotate 90 CW' => 6, 'Mirror horizontal and rotate 90 CW' => 7, 'Rotate 270 CW' => 8
      }.freeze

      def initialize(jpeg_scaler = VipsScaler.new)
        @jpeg_scaler = jpeg_scaler
      end

      def accepts_mime?(mime, ext = nil)
        RAW_EXTS.include?(ext.to_s)
      end

      def scale(infile:nil, outfile:nil, mime:nil, ext:nil, size: 100, exif: nil, **)
        Tempfile.create(['raw-embedded', '.jpg']) do |tmp|
          tmp.binmode
          return unless read_embedded(infile, exif, tmp) || extract_largest(infile, tmp)
          @jpeg_scaler.scale(infile: tmp.path, outfile: outfile, mime: VipsScaler::JPEG_MIME,
                             size: size, orientation: orientation(infile, exif))
        end
      end

      private

      # Byte ranges from the EXIF already read by MimeProcessor, so no exiftool run.
      # Offsets are absolute for TIFF-based RAWs (NEF, ARW, DNG); the SOI check rejects
      # formats where they are relative, which then fall back to extract_largest.
      def read_embedded(infile, exif, tmp)
        return false unless exif
        EMBEDDED_TAGS.each do |tag|
          start, length = exif["#{tag}Start"], exif["#{tag}Length"]
          next unless start.is_a?(Integer) && length.is_a?(Integer) && length >= MIN_EMBEDDED_BYTES
          data = File.binread(infile, length, start)
          next unless data&.start_with?(JPEG_SOI)
          tmp.write(data)
          tmp.flush
          return true
        end
        false
      end

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
      def orientation(infile, exif)
        value = exif ? exif['Orientation'] : Open3.capture2('exiftool', '-n', '-s3', '-Orientation', infile).first.strip
        ORIENTATIONS[value] || (1..8).find { |o| o.to_s == value.to_s } || 1
      end
    end
  end
end
