require_relative '../metador_processor_test'

class ImageJpegTest < MetadorProcessorTest
  it "downscale jpeg" do
    input = {
        source_file: 'image/IMG_2033.JPG',
        query: {
            preview: {
                size: 100,
                destination_file: "generated/IMG_2033-downscale"
            },
            meta: true,
        }
    }

    expected = {
        mime: 'image/jpeg',
        preview: {
            width: 75,
            height: 100,
            destination_file: 'generated/IMG_2033-downscale.jpg',
            "_debug" => {scaler: "Metador::Image::VipsScaler"}
        }
    }.merge(input)

    assert_matches_metador(input, expected)
  end

  it "do not upscale jpeg" do
    input = {
        source_file: 'image/IMG_2033.JPG',
        query: {
            preview: {
                size: 2500,
                destination_file: "generated/IMG_2033-no-upscale"
            },
            meta: true
        }
    }

    expected = {
        mime: 'image/jpeg',
        preview: {
            width: 1536,
            height: 2048,
            destination_file: 'generated/IMG_2033-no-upscale.jpg',
            "_debug" => {scaler: "Metador::Image::VipsScaler"}
        }
    }.merge(input)

    assert_matches_metador(input, expected)
  end
end