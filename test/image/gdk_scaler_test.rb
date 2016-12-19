require_relative '../test_helper'
require 'gdk_pixbuf2'
require 'benchmark'
require 'metador/image/gdk_scaler'

class GdkScalerTest < FixturedTest


#  test "vips tiff scale" do
#    time = Benchmark.realtime do
#      ImageService.new.scale(infile: "#{SAMPLE_DIR}/804335.tif", outfile: "#{GEN_DIR}/dupa3s.jpg", ext:'jpg', size:200, engine: :vips)
#    end
#    p "VIPS big tiff #{time}"
#  end

  before do
    @scaler = Metador::Image::GdkScaler.new
    assert ! File.exist?("#{GEN_DIR}/t1gdk.jpg")
  end


  it "pixbuf tiff scale" do
    time = Benchmark.realtime do
      assert @scaler.scale(infile:"#{SAMPLE_DIR}/804335.tif", outfile: "#{GEN_DIR}/t1gdk.jpg", ext:'jpg', size:200)
    end
    assert File.exist? "#{GEN_DIR}/t1gdk.jpg"
    recognized, x, y = Gdk::Pixbuf.get_file_info("#{GEN_DIR}/t1gdk.jpg")
    assert recognized
    assert_equal 200, x
    assert_equal 95, y
    p "Pixbuf big tiff #{time}"
  end

  it "jpeg resize" do
    time = Benchmark.realtime do
      @scaler.scale(infile:"#{SAMPLE_DIR}/Metro_de_Madrid_-_Cuatro_Caminos_01.jpg", outfile: "#{GEN_DIR}/t2gdk.jpg", ext:'jpg', size:600)
    end
    assert File.exist? "#{GEN_DIR}/t2gdk.jpg"
    recognized, x, y = Gdk::Pixbuf.get_file_info("#{GEN_DIR}/t2gdk.jpg")
    assert recognized
    assert_equal 450, x
    assert_equal 600, y
    p time
  end

  it "smaller should not scale" do
    time = Benchmark.realtime do
      @scaler.scale(infile:"#{SAMPLE_DIR}/hotlink.png", outfile: "#{GEN_DIR}/t3gdk.jpg", ext:'jpg', size:600)
    end
    assert File.exist? "#{GEN_DIR}/t3gdk.jpg"
    recognized, x, y = Gdk::Pixbuf.get_file_info("#{GEN_DIR}/t3gdk.jpg")
    assert recognized
    assert_equal 600, x
    assert_equal 468, y
    p time
  end

  describe "Reorients" do
    before do
      @src = Gdk::Pixbuf.new("#{SAMPLE_DIR}/orientationtest.png")
    end

    it "0 no orientation" do
      pb = @scaler.pixbuf_reorient @src
      assert_equal [0, 0, 0, 128, 128, 128, 0, 0, 170, 170, 170, 255, 255, 255], pb.pixels.bytes
    end

    #0 row, 0 column
    it "1 top left" do
      assert @src.set_option('orientation', "1")
      pb = @scaler.pixbuf_reorient @src
      assert_equal [0, 0, 0, 128, 128, 128, 0, 0, 170, 170, 170, 255, 255, 255], pb.pixels.bytes
    end

    it "2 top right" do
      assert @src.set_option('orientation', "2")
      pb = @scaler.pixbuf_reorient @src
      assert_equal [128, 128, 128, 0, 0, 0, 0, 0, 255, 255, 255, 170, 170, 170], pb.pixels.bytes
    end

    it "3 bottom right" do
      assert @src.set_option('orientation', "3")
      pb = @scaler.pixbuf_reorient @src
      assert_equal [255, 255, 255, 170, 170, 170, 0, 0, 128, 128, 128, 0, 0, 0], pb.pixels.bytes
    end

    it "4 bottom left" do
      assert @src.set_option('orientation', "4")
      pb = @scaler.pixbuf_reorient @src
      assert_equal [170, 170, 170, 255, 255, 255, 0, 0, 0, 0, 0, 128, 128, 128], pb.pixels.bytes
    end

    it "5 left top" do
      assert @src.set_option('orientation', "5")
      pb = @scaler.pixbuf_reorient @src
      assert_equal [0, 0, 0, 170, 170, 170, 0, 0, 128, 128, 128, 255, 255, 255], pb.pixels.bytes
    end

    it "6 right top" do
      assert @src.set_option('orientation', "6")
      pb = @scaler.pixbuf_reorient @src
      assert_equal [170, 170, 170, 0, 0, 0, 0, 0, 255, 255, 255, 128, 128, 128], pb.pixels.bytes
    end

    it "7 right bottom" do
      assert @src.set_option('orientation', "7")
      pb = @scaler.pixbuf_reorient @src
      assert_equal [255, 255, 255, 128, 128, 128, 0, 0, 170, 170, 170, 0, 0, 0], pb.pixels.bytes
    end

    it "8 left bottom" do
      assert @src.set_option('orientation', "8")
      pb = @scaler.pixbuf_reorient @src
      assert_equal [128, 128, 128, 255, 255, 255, 0, 0, 0, 0, 0, 170, 170, 170], pb.pixels.bytes
    end

  end

end