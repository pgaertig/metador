require_relative '../test_helper'
require 'vips'
require 'minitest/mock'

class RawEmbeddedScalerTest < FixturedTest

  before do
    @scaler = Metador::Image::RawEmbeddedScaler.new
  end

  def scaled_size(path)
    img = Vips::Image.new_from_file(path)
    [img.width, img.height]
  end

  def exif_of(path)
    Metador::Util::ExifExtractor.new.extract(path)
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

  it "reads embedded JPEG from EXIF offsets without running exiftool" do
    out = "#{GEN_DIR}/raw4-he-offsets.jpg"
    nef = "#{@image_dir}/raw4-he.NEF"
    exif = exif_of(nef)
    fail_exiftool = ->(*) { flunk 'exiftool should not run' }
    Open3.stub(:capture2, fail_exiftool) do
      Open3.stub(:capture2e, fail_exiftool) do
        @scaler.scale(infile: nef, outfile: out, ext: 'nef', size: 600, exif: exif)
      end
    end
    assert_equal [600, 400], scaled_size(out)
  end

  it "rotates a portrait shot using Orientation from EXIF" do
    out = "#{GEN_DIR}/raw1-offsets.jpg"
    nef = "#{@image_dir}/raw1.NEF"
    @scaler.scale(infile: nef, outfile: out, ext: 'nef', size: 600, exif: exif_of(nef))
    assert_equal [401, 600], scaled_size(out)
  end

  it "falls back to exiftool when EXIF has no offsets" do
    out = "#{GEN_DIR}/raw2-fallback.jpg"
    cr3 = "#{@image_dir}/raw2.CR3"
    exif = exif_of(cr3)
    refute exif.key?('JpgFromRawStart')
    @scaler.scale(infile: cr3, outfile: out, ext: 'cr3', size: 600, exif: exif)
    assert_equal [600, 400], scaled_size(out)
  end

  it "ignores offsets that do not point at a JPEG" do
    out = "#{GEN_DIR}/raw4-bad-offsets.jpg"
    nef = "#{@image_dir}/raw4-he.NEF"
    exif = exif_of(nef).merge('JpgFromRawStart' => 0, 'PreviewImageStart' => 0, 'OtherImageStart' => 0)
    @scaler.scale(infile: nef, outfile: out, ext: 'nef', size: 600, exif: exif)
    assert_equal [600, 400], scaled_size(out)
  end
end
