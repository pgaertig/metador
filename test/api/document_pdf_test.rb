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
            _debug: {scaler: "Metador::Image::MagickScaler", process_time: Float}
        },
        _debug: {process_time: Float}
    }.merge(input)

    assert_matches_metador(input, expected)
  end

  it "do not upscale pdf above rendered page size" do
    input = {
        source_file: 'document/HallerVC07.pdf',
        query: {
            preview: {
                size: 1600,
                destination_file: "generated/HallerVC07-pdf-no-upscale"
            },
            meta: true,
        }
    }
    expected = {
        mime: 'application/pdf',
        preview: {
            width: 612,
            height: 792,
            destination_file: 'generated/HallerVC07-pdf-no-upscale.jpg',
            _debug: {scaler: "Metador::Image::MagickScaler", process_time: Float}
        },
        _debug: {process_time: Float}
    }.merge(input)

    assert_matches_metador(input, expected)
  end
end
