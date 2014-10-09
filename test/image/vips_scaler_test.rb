require_relative '../test_helper'
require 'gdk_pixbuf2'
require 'benchmark'
require 'metador/image/vips_scaler'

class VipsScalerTest < FixturedTest

  before do
    FileUtils.rm_rf(Dir.glob(File.join(GEN_DIR, '*')))
    @scaler = Metador::Image::VipsScaler.new
    assert ! File.exist?("#{GEN_DIR}/t1.jpg")
  end


  it "tiff scale" do
    skip "multipage tiff doesn't work"
    time = Benchmark.realtime do
      assert @scaler.scale(infile:"#{IMAGE_DIR}/804335.tif", outfile: "#{GEN_DIR}/t1.jpg", ext:'jpg', size:200)
    end
    assert File.exist? "#{GEN_DIR}/t1.jpg"
    recognized, x, y = Gdk::Pixbuf.get_file_info("#{GEN_DIR}/t1.jpg")
    assert recognized
    assert_equal 200, x
    assert_equal 95, y
    p "Pixbuf big tiff #{time}"
  end

  it "jpeg resize" do
    time = Benchmark.realtime do
      @scaler.scale(infile:"#{IMAGE_DIR}/Metro_de_Madrid_-_Cuatro_Caminos_01.jpg", outfile: "#{GEN_DIR}/t2.jpg", ext:'jpg', size:600)
    end
    assert File.exist? "#{GEN_DIR}/t2.jpg"
    recognized, x, y = Gdk::Pixbuf.get_file_info("#{GEN_DIR}/t2.jpg")
    assert recognized
    assert_equal 450, x
    assert_equal 600, y
    p time
  end

  it "smaller should not scale" do
    skip "doesn't work in scaler"
    time = Benchmark.realtime do
      @scaler.scale(infile:"#{IMAGE_DIR}/hotlink.png", outfile: "#{GEN_DIR}/t3.jpg", ext:'jpg', size:600)
    end
    assert File.exist? "#{GEN_DIR}/t3.jpg"
    recognized, x, y = Gdk::Pixbuf.get_file_info("#{GEN_DIR}/t3.jpg")
    assert recognized
    assert_equal 600, x
    assert_equal 468, y
    p time
  end


  it "in memory" do
    binary = @scaler.scale(infile: "#{IMAGE_DIR}/IMG_2033.JPG" ,ext:'jpg')
    assert_equal 2069, binary.size
  end

end