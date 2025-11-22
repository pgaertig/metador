require_relative '../test_helper'

class ExifExtractorTest < FixturedTest

  GEN_DIR = File.join(TEST_FIXTURES, 'generated')

  it "recognizes image" do
    ftd = Metador::Util::ExifExtractor.new
    assert File.exist? SAMPLE_DIR + "/804335.tif"
    assert_equal 'image/tiff', ftd.extract(SAMPLE_DIR + "/804335.tif")["MIMEType"]
  end

  it "recognizes raw photo" do
    ftd = Metador::Util::ExifExtractor.new
    assert File.exist? SAMPLE_DIR + "/894439.cr2"
    assert_equal 'image/x-canon-cr2', ftd.extract(SAMPLE_DIR + "/894439.cr2")["MIMEType"]
  end

end