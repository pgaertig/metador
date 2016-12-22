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

  def assert_matches_metador input, expected_output_expression
    result = @metador.consume!(JSON.unparse(input))
    assert_json_match(expected_output_expression, result)
  end

end