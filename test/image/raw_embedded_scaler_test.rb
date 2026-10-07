require_relative '../test_helper'
require 'open3'
require 'vips'

class RawEmbeddedScalerTest < FixturedTest

  before do
    @scaler = Metador::Image::RawEmbeddedScaler.new
  end

  def scaled_size(path)
    img = Vips::Image.new_from_file(path)
    [img.width, img.height]
  end

  it "accepts camera RAW extensions only" do
    assert @scaler.accepts_mime?('image/x-nikon-nef', 'nef')
    assert @scaler.accepts_mime?('image/tiff', 'nef')
    assert @scaler.accepts_mime?('image/x-canon-cr3', 'cr3')
    refute @scaler.accepts_mime?('image/jpeg', 'jpg')
    refute @scaler.accepts_mime?('image/tiff', 'tif')
    refute @scaler.accepts_mime?('image/x-nikon-nef', nil)
  end

  it "scales Nikon High Efficiency* NEF unsupported by LibRaw" do
    out = "#{GEN_DIR}/raw4-he-embedded.jpg"
    @scaler.scale(infile: "#{@image_dir}/raw4-he.NEF", outfile: out, ext: 'nef', size: 600)
    assert_equal [600, 400], scaled_size(out)
  end

  it "keeps RAW orientation of a portrait shot" do
    out = "#{GEN_DIR}/raw1-embedded.jpg"
    @scaler.scale(infile: "#{@image_dir}/raw1.NEF", outfile: out, ext: 'nef', size: 600)
    assert_equal [401, 600], scaled_size(out)
  end

  it "leaves no output when there is no embedded JPEG" do
    out = "#{GEN_DIR}/not-raw-embedded.jpg"
    @scaler.scale(infile: "#{@image_dir}/sample.heic", outfile: out, ext: 'nef', size: 600)
    refute File.exist?(out)
  end

  it "libraw_convert fails on data LibRaw can't decode instead of writing noise" do
    out = "#{GEN_DIR}/raw4-he-libraw.ppm"
    _, status = Open3.capture2e('libraw_convert', "#{@image_dir}/raw4-he.NEF", out)
    refute status.success?
  end
end
