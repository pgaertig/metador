require 'streamio-ffmpeg'

class Metador::FfmpegVideoProcessor
  def process(data, options = {})
    movie = FFMPEG::Movie.new(data[:full_path])
    if movie.valid?
      d = movie.duration
      n = d > 30 ? 3 : 1
      n += (Math.min(3600, d) / 300).to_i # each 5 minutes adds one more frame

      1..n.each {|x|
        t = ((x - 0.5) * d / n).to_i
        ndata = data.dup
        ndata[:full_result_path] + ("-%02d.jpg" % x)
        ndata[:result_path] + ("-%02d.jpg" % x)
        process_frame(x, t, ndata, options)
      }
    end
  end

  def process_frame(x, t, data, outfile, options = {})
    movie.screenshot(data[:full_result_path],
                     seek_time: t,
                     resolution: "#{data[:width]}x#{data[:height]}",
                     preserve_aspect_ratio: :width)

  end
end