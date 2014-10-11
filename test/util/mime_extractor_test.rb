require_relative '../test_helper'

class MimeExtractorTest < FixturedTest

  GEN_DIR = File.join(TEST_FIXTURES, 'generated')

  it "recognizes image" do
    ftd = Metador::Util::MimeExtractor.new
    assert File.exist? SAMPLE_DIR + "/804335.tif"
    assert_equal 'image/tiff', ftd.find_mime(SAMPLE_DIR + "/804335.tif")
  end

  it "recognizes raw photo" do
    ftd = Metador::Util::MimeExtractor.new
    assert File.exist? SAMPLE_DIR + "/894439.cr2"
    assert_equal 'image/x-canon-cr2', ftd.find_mime(SAMPLE_DIR + "/894439.cr2")
  end

end