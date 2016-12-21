require_relative '../metador_processor_test'

class ImageRawTest < MetadorProcessorTest
  it "process raw NEF" do
    input = {
        source_file: 'image/raw1.NEF',
        query: {
            preview: {
                size: 600,
                destination_file: "generated/raw1-nef"
            },
            meta: true,
        }
    }

    expected = {
        mime: 'image/tiff', #that is bad really
        preview: {
            width: 401,
            height: 600,
            destination_file: 'generated/raw1-nef.jpg',
            _debug: {scaler: "Metador::Image::MagickScaler", process_time: Float}
        },
        _debug: {process_time: Float}
    }.merge(input)

    assert_matches_metador(input, expected)
  end
end