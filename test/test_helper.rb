require 'bundler/setup'
require 'metador'
require 'minitest/autorun'
require 'ostruct'


class FixturedTest < MiniTest::Spec
  TEST_FIXTURES = File.expand_path('../../../kp-test-files', __FILE__)
  IMAGE_DIR = File.join(TEST_FIXTURES, 'images')
  GEN_DIR = TEST_FIXTURES + "/generated"

  before do
    #Clean output dir
    FileUtils.rm_rf(Dir.glob(File.join(GEN_DIR, '*')))

    @config = OpenStruct.new({
                                 src_dir: TEST_FIXTURES,
                                 dest_dir: TEST_FIXTURES + "/generated"
                             })
  end

end