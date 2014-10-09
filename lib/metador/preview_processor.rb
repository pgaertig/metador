require 'mini_magick'




class Metador::PreviewProcessor < Metador::BaseProcessor

  SCALER = Metador::Image::GdkScaler

  def process(data, file_resolver:)
    preview_query = data[:query][:preview]
    if preview_query
      preview = data[:preview] = {destination_file: preview_query[:destination_file] + '.jpg'}
      dest_path = file_resolver.resolve_dest(preview[:destination_file])

      SCALER.new.scale(
          infile: file_resolver.resolve_src(data[:source_file]),
          outfile: dest_path,
          size: preview_query[:size]
      )

      info = MiniMagick::Image.new dest_path
      preview.merge!(width: info['width'], height: info['height'])
      data
    end
  end
end