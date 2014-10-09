require_relative 'test_helper'

class MetadorProcessorTest < FixturedTest

  before do
    @metador = Metador::MetadorProcessor.new(@config)
  end


  it "converts jpeg image" do
    data = {
        source_file: 'images/IMG_2033.JPG',
        query: {
            preview: {
                size: 100,
                destination_file: "t1"
            },
            meta: true,
        }
    }

    result = @metador.process(data)

    assert result
    p result
    assert_equal 75, data[:preview][:width]
    assert_equal 100, data[:preview][:height]
  end

  it "converts video" do

  end

  it "converts pdf document" do

  end
end