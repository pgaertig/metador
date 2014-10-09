class ImageService
  def scale(infile:nil, outfile:nil, ext:nil, size: 100, engine: :pixbuf)
    #time = Benchmark.realtime do
    if engine == :vips
      resize_vips infile, outfile, size, ext
    elsif engine == :pixbuf
      resize_pixbuf infile, outfile, size, ext =~ /jpg/ ? 'jpeg' : ext
    end
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

  @@verbose = false

  def resize_pixbuf infile, outfile, size, filetype
    pixbuf = Gdk::Pixbuf.new(file:infile, width:size, height: size)
    pixbuf = pixbuf_reorient pixbuf
    pixbuf.save(outfile, filetype)
    return pixbuf.width, pixbuf.height
  end



  def resize_vips infile, outfile, size, filetype
    mask = [
        [-1, -1,  -1],
        [-1,  32, -1,],
        [-1, -1,  -1]
    ]
    m = VIPS::Mask.new mask, 24, 0

    shrink = 1

    im = nil
    a = vips_load_file infile, filetype

    # largest dimension
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



      puts "jpeg shrink on load of #{load_shrink}" if @@verbose

      a = vips_load_file filetype, load_shrink

      # and recalculate the shrink we need, since the dimensions have
      # changed
      d = [a.x_size, a.y_size].max
      shrink = d / size.to_f
    end


    ishrink = shrink.to_i

    # size after int shrink
    id = (d / ishrink).to_i

    # therefore residual float scale (note! not shrink)
    rscale = size.to_f / id

    puts "block shrink by #{ishrink}" if @@verbose
    puts "residual scale by #{rscale}" if @@verbose

    a = a.shrink(ishrink)

    # the convolution will break sequential access: we need to cache a few
    # scanlines
    a = a.tile_cache(a.x_size, 1, 30)

    # vips has other interpolators, eg. :nohalo ... see the output of
    # "vips list classes" at the command-line
    #
    # :bicubic is well-known and mostly good enough
    a = a.affinei_resize(:nohalo, rscale)

    # this will look a little "soft", apply a gentle sharpen
    a = a.conv(m)
    #jpeg = a.jpeg
    jpeg = VIPS::JPEGWriter.new(a, {:quality => 75})
    jpeg.remove_icc
    jpeg.remove_exif

    # finally ... write to the output
    #
    # this call will run the pipeline we have built above across all your
    # CPUs, though for a simple pipeline like this you'll be spending
    # most of your time in the file import / export libraries, which are
    # generally single-threaded

    #
    outfile ? jpeg.write(outfile) : jpeg.to_memory
  end


  def vips_load_file(infile, filetype = "jpg", shrink=1)
    if filetype == "jpg"
      return VIPS::Image.jpeg infile,
                              :shrink_factor => shrink,
                              :sequential => true
    elsif filetype == "tif"
      return VIPS::Image.tiff infile,
                              :sequential => true
    elsif filetype == "png"
      return VIPS::Image.png infile,
                             :sequential => true
    else
      return VIPS::Image.new infile
    end
  end



end