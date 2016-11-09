require 'mini_magick'

class Metador::Image::PreviewProcessor

  pattr_initialize :config, :path_mapper, :scalers

  def self.build(config)
    new(
        config,
        Metador::Util::PathMapper.new(config),
        [
            Metador::Image::VipsScaler.new,
            Metador::Image::GdkScaler.new,
            Metador::Image::MagickScaler.new
        ]
    )
  end

  def process(data)
    preview_query = data[:query][:preview]
    if preview_query
      preview = {destination_file: preview_query[:destination_file] + '.jpg'}
      dest_path = path_mapper.map_dest(preview[:destination_file])

      scalers.each do |scaler|
        begin
          scaler.scale(
              infile: path_mapper.map_src(data[:source_file]),
              outfile: dest_path,
              size: preview_query[:size]
          ) if scaler.accepts_mime?(data[:mime])

          if File.exist?(dest_path)
            info = MiniMagick::Image.new dest_path
            preview.merge!(width: info['width'], height: info['height'], "_debug" => {scaler: scaler.class.name})
            data[:preview] = preview
            break
          end
        rescue => e
          puts "Scaler #{scaler.class} failed with #{data[:source_file]}: #{e} #{e.backtrace}"
        end
      end

      data
    end
  end

  def accepts?(data)
    data[:mime] && scalers.find {|s| s.accepts_mime?(data[:mime])}
  end
end
