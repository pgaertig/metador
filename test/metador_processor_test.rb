require_relative 'test_helper'

class MetadorProcessorTest < FixturedTest

  #abstract

  before do
    @config = OpenStruct.new({
                                 path_mappings: [
                                     {"from" => 'image/', "to" =>  @image_dir },
                                     {"from" => 'video/', "to" =>  @video_dir },
                                     {"from" => 'audio/', "to" =>  @audio_dir },
                                     {"from" => 'document/', "to" =>  @document_dir },
                                     {"from" => 'generated/', "to" => GEN_DIR}
                                 ]})
    @metador = Metador::MessageHandler.new(@config)
  end

  def assert_matches_metador input, expected
    actual = JSON.parse(@metador.consume!(JSON.generate(input)), symbolize_names: true)
    assert_matches_subset expected, actual
  end

  def assert_matches_subset expected, actual, path = []
    at = path.empty? ? '(root)' : path.join('.')
    case expected
    when Hash
      assert_kind_of Hash, actual, at
      expected.each do |key, value|
        assert actual.key?(key), "missing key at #{at}.#{key}"
        assert_matches_subset value, actual[key], path + [key]
      end
    when Array
      assert_kind_of Array, actual, at
      assert_equal expected.size, actual.size, "array size at #{at}"
      expected.each_with_index { |value, i| assert_matches_subset value, actual[i], path + [i] }
    when Module
      assert_kind_of expected, actual, at
    else
      assert_equal expected, actual, at
    end
  end

end