require 'bundler/setup'
require 'metador'
require 'minitest/autorun'
require 'ostruct'


class FixturedTest < MiniTest::Spec
  TEST_FIXTURES = File.expand_path('../../../kp-test-files', __FILE__)
  SAMPLE_DIR = File.join(TEST_FIXTURES, 'samples/')
  GEN_DIR = TEST_FIXTURES + "/generated/"

  before do
    #Clean output dir
    #FileUtils.rm(Dir.glob(File.join(GEN_DIR, '*')))

    @config = OpenStruct.new({
        path_mappings: [
            {"from" => 'samples/', "to" => SAMPLE_DIR},
            {"from" => 'generated/', "to" => GEN_DIR}
        ]})
  end

end