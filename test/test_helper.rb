require 'bundler/setup'
require 'metador'
require 'minitest/autorun'
require 'ostruct'


class FixturedTest < MiniTest::Spec
  CONTAINER_TEST_FILES = '/rubyapp-test-files'
  TEST_FIXTURES = File.directory?(CONTAINER_TEST_FILES) ?
      CONTAINER_TEST_FILES : File.expand_path('../../../kp-test-files', __FILE__)
  SAMPLE_DIR = File.join(TEST_FIXTURES, 'samples/')
  GEN_DIR = TEST_FIXTURES + "/generated/"

  @@clean_dir = true
  before do
    #Clean output dir
    if @@clean_dir
      FileUtils.rm(Dir.glob(File.join(GEN_DIR, '*')))
      @@clean_dir = false
    end

    @config = OpenStruct.new({
        path_mappings: [
            {"from" => 'samples/', "to" => SAMPLE_DIR},
            {"from" => 'generated/', "to" => GEN_DIR}
        ]})
  end

end