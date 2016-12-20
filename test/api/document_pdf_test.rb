require_relative '../metador_processor_test'

class JpegTest < MetadorProcessorTest
  it "converts pdf document" do
    input = {
        source_file: 'document/HallerVC07.pdf',
        query: {
            preview: {
                size: 200,
                destination_file: "generated/HallerVC07-pdf"
            },
            meta: true,
        }
    }
    expected = {
        mime: 'application/pdf',
        preview: {
            width: 155,
            height: 200,
            destination_file: 'generated/HallerVC07-pdf.jpg',
            "_debug" => {scaler: "Metador::Image::MagickScaler"}
        }
    }.merge(input)

    assert_matches_metador(input, expected)
  end
end