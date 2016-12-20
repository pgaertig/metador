require 'bundler/setup'
require 'metador'
require 'minitest/autorun'
require 'ostruct'
require 'json_expressions/minitest'


class FixturedTest < MiniTest::Spec
  CONTAINER_TEST_FILES = '/rubyapp-test-files'
  TEST_FIXTURES = File.directory?(CONTAINER_TEST_FILES) ?
      CONTAINER_TEST_FILES : File.expand_path('../../../kp-test-files', __FILE__)
  SAMPLE_DIR = File.join(TEST_FIXTURES, 'samples/')
  GEN_DIR = TEST_FIXTURES + "/generated/"

  @@clean_dir ||= false
  before do
    @image_dir = File.join(TEST_FIXTURES,'image/')
    @video_dir = File.join(TEST_FIXTURES,'video/')
    @document_dir = File.join(TEST_FIXTURES, 'document/')

    #Clean output dir
    unless @@clean_dir
      FileUtils.rm(Dir.glob(File.join(GEN_DIR, '*')))
      @@clean_dir = true
    end


  end

end