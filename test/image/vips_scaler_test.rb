require_relative '../test_helper'
require 'gdk_pixbuf2'
require 'benchmark'
require 'metador/image/vips_scaler'
require 'vips'

class VipsScalerTest < FixturedTest

  before do
    @scaler = Metador::Image::VipsScaler.new
    #assert ! File.exist?("#{GEN_DIR}/t1.jpg")
  end

  it "tiff scale" do
    time = Benchmark.realtime do
      #24000x11433
      assert @scaler.scale(infile:"#{SAMPLE_DIR}/804335.tif", outfile: "#{GEN_DIR}/t1vips.jpg", ext:'tif', size:200)
    end
    assert File.exist? "#{GEN_DIR}/t1vips.jpg"
    recognized, x, y = Gdk::Pixbuf.get_file_info("#{GEN_DIR}/t1vips.jpg")
    assert recognized
    assert_equal 200, x
    assert_equal 95, y
    p "Pixbuf big tiff #{time}"
  end

  it "jpeg resize" do
    time = Benchmark.realtime do
      @scaler.scale(infile:"#{SAMPLE_DIR}/Metro_de_Madrid_-_Cuatro_Caminos_01.jpg", outfile: "#{GEN_DIR}/t2vips.jpg", ext:'jpg', size:600)
    end
    assert File.exist? "#{GEN_DIR}/t2vips.jpg"
    recognized, x, y = Gdk::Pixbuf.get_file_info("#{GEN_DIR}/t2vips.jpg")
    assert recognized
    assert_equal 450, x
    assert_equal 600, y
    p time
  end

  it "smaller jpeg should not resize" do
    time = Benchmark.realtime do
      #334x500
      @scaler.scale(infile:"#{SAMPLE_DIR}/895c032c06bbde148c036aff9d259cfac63aa6ac.jpg", outfile: "#{GEN_DIR}/t3vips.jpg", ext:'jpg', size:800)
    end
    assert File.exist? "#{GEN_DIR}/t3vips.jpg"
    recognized, x, y = Gdk::Pixbuf.get_file_info("#{GEN_DIR}/t3vips.jpg")
    assert recognized
    assert_equal 334, x
    assert_equal 500, y
    p time
  end

  it "smaller jpeg should not resize to extra large" do
    time = Benchmark.realtime do
      @scaler.scale(infile:"#{SAMPLE_DIR}/Metro_de_Madrid_-_Cuatro_Caminos_01.jpg", outfile: "#{GEN_DIR}/t4vips.jpg", ext:'jpg', size:30000)
    end
    assert File.exist? "#{GEN_DIR}/t4vips.jpg"
    recognized, x, y = Gdk::Pixbuf.get_file_info("#{GEN_DIR}/t4vips.jpg")
    assert recognized
    assert_equal 1920, x
    assert_equal 2560, y
    p time
  end

  it "smaller png should not scale" do
    time = Benchmark.realtime do
      @scaler.scale(infile:"#{SAMPLE_DIR}/hotlink.png", outfile: "#{GEN_DIR}/t5vips.jpg", ext:'png', size:600)
    end
    assert File.exist? "#{GEN_DIR}/t5vips.jpg"
    recognized, x, y = Gdk::Pixbuf.get_file_info("#{GEN_DIR}/t5vips.jpg")
    assert recognized
    assert_equal 368, x
    assert_equal 287, y
    p time
  end


  it "in memory" do
    binary = @scaler.scale(infile: "#{@image_dir}/IMG_2033.JPG" ,ext:'jpg')
    assert_in_delta(1900, binary.size, 100)
  end

  it "reorient downscaled jpeg" do
    time = Benchmark.realtime do
      # 450x600 -> 300x225
      @scaler.scale(infile:"#{SAMPLE_DIR}/exif-orientation-examples/Landscape_8.jpg", outfile: "#{GEN_DIR}/t6vips.jpg", ext:'jpg', size:300)
    end
    assert File.exist? "#{GEN_DIR}/t6vips.jpg"
    recognized, x, y = Gdk::Pixbuf.get_file_info("#{GEN_DIR}/t6vips.jpg")
    assert recognized
    assert_equal 300, x
    assert_equal 225, y
    p time
  end

  it "reorient non-scaled jpeg" do
    time = Benchmark.realtime do
      # 450x600 -> 300x225
      @scaler.scale(infile:"#{SAMPLE_DIR}/exif-orientation-examples/Landscape_8.jpg", outfile: "#{GEN_DIR}/t6vips.jpg", ext:'jpg', size:800)
    end
    assert File.exist? "#{GEN_DIR}/t6vips.jpg"
    recognized, x, y = Gdk::Pixbuf.get_file_info("#{GEN_DIR}/t6vips.jpg")
    assert recognized
    assert_equal 600, x
    assert_equal 450, y
    p time
  end


end