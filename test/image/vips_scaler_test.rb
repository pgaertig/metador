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
      assert @scaler.scale(infile:"#{SAMPLE_DIR}/804335.tif", outfile: "#{GEN_DIR}/t1.jpg", ext:'tiff', size:200)
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
      @scaler.scale(infile:"#{SAMPLE_DIR}/Metro_de_Madrid_-_Cuatro_Caminos_01.jpg", outfile: "#{GEN_DIR}/t2.jpg", ext:'jpg', size:600)
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
      @scaler.scale(infile:"#{SAMPLE_DIR}/hotlink.png", outfile: "#{GEN_DIR}/t3.jpg", ext:'png', size:600)
    end
    assert File.exist? "#{GEN_DIR}/t3.jpg"
    recognized, x, y = Gdk::Pixbuf.get_file_info("#{GEN_DIR}/t3.jpg")
    assert recognized
    assert_equal 600, x
    assert_equal 468, y
    p time
  end


  it "in memory" do
    binary = @scaler.scale(infile: "#{SAMPLE_DIR}/IMG_2033.JPG" ,ext:'jpg')
    assert_equal 1941, binary.size
  end

  describe "Reorients" do

    before do
      skip "Test need reimplementation for ruby-vips-1.0"
      @src = Vips::Image.new_from_file("#{SAMPLE_DIR}/orientationtest.png")
    end

    def src_to_arr
      src2 = @scaler.vips_reorient @src
      src2.to_a.flatten.collect(&:to_i)
    end

    it "0 no orientation" do
      assert_equal [0, 0, 0, 128, 128, 128, 170, 170, 170, 255, 255, 255], src_to_arr
    end

    #0 row, 0 column
    it "1 top left" do
      @src.set_int("exif-Orientation", 1)
      assert_equal [0, 0, 0, 128, 128, 128, 170, 170, 170, 255, 255, 255], src_to_arr
    end

    it "2 top right" do
      @src.set_int("exif-Orientation", 2)
      assert_equal [128, 128, 128, 0, 0, 0, 255, 255, 255, 170, 170, 170], src_to_arr
    end

    it "3 bottom right" do
      @src.set("exif-Orientation", "3")
      assert_equal [255, 255, 255, 170, 170, 170, 128, 128, 128, 0, 0, 0], src_to_arr
    end

    it "4 bottom left" do
      @src.set("exif-Orientation", "4")
      assert_equal [170, 170, 170, 255, 255, 255, 0, 0, 0, 128, 128, 128], src_to_arr
    end

    it "5 left top" do
      @src.set("exif-Orientation", "5")
      assert_equal [0, 0, 0, 170, 170, 170, 128, 128, 128, 255, 255, 255], src_to_arr
    end

    it "6 right top" do
      @src.set("exif-Orientation", "6")
      assert_equal [170, 170, 170, 0, 0, 0, 255, 255, 255, 128, 128, 128], src_to_arr
    end

    it "7 right bottom" do
      @src.set("exif-Orientation", "7")
      assert_equal [255, 255, 255, 128, 128, 128, 170, 170, 170, 0, 0, 0], src_to_arr
    end

    it "8 left bottom" do
      @src.set("exif-Orientation", "8")
      assert_equal [128, 128, 128, 255, 255, 255, 0, 0, 0, 170, 170, 170], src_to_arr
    end

  end

end