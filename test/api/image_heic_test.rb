require_relative '../metador_processor_test'

class ImageHeicTest < MetadorProcessorTest
  it "downscale heic" do
    input = {
        source_file: 'image/sample.heic',
        query: {
            preview: {
                size: 400,
                destination_file: "generated/heic-downscale"
            },
            meta: true,
        }
    }

    expected = {
        mime: 'image/heif',
        preview: {
            width: 400,
            height: 267,
            destination_file: 'generated/heic-downscale.jpg',
            _debug: {scaler: "Metador::Image::VipsScaler", process_time: Float}
        },
        _debug: {process_time: Float}
    }.merge(input)

    assert_matches_metador(input, expected)
  end

  it "do not upscale heic above source resolution" do
    input = {
        source_file: 'image/sample.heic',
        query: {
            preview: {
                size: 1600,
                destination_file: "generated/heic-no-upscale"
            },
            meta: true,
        }
    }

    expected = {
        mime: 'image/heif',
        preview: {
            width: 1440,
            height: 960,
            destination_file: 'generated/heic-no-upscale.jpg',
            _debug: {scaler: "Metador::Image::VipsScaler", process_time: Float}
        },
        _debug: {process_time: Float}
    }.merge(input)

    assert_matches_metador(input, expected)
  end

  it "downscale heic carrying camera exif" do
    input = {
        source_file: 'image/sample-exif.heic',
        query: {
            preview: {
                size: 400,
                destination_file: "generated/heic-exif-downscale"
            },
            meta: true,
        }
    }

    expected = {
        mime: 'image/heic',
        preview: {
            width: 400,
            height: 272,
            destination_file: 'generated/heic-exif-downscale.jpg',
            _debug: {scaler: "Metador::Image::VipsScaler", process_time: Float}
        },
        _debug: {process_time: Float}
    }.merge(input)

    assert_matches_metador(input, expected)
  end

  it "apply container rotation from irot box" do
    input = {
        source_file: 'image/sample-rotated.heic',
        query: {
            preview: {
                size: 400,
                destination_file: "generated/heic-rotated"
            },
            meta: true,
        }
    }

    expected = {
        mime: 'image/heif',
        preview: {
            width: 225,
            height: 400,
            destination_file: 'generated/heic-rotated.jpg',
            _debug: {scaler: "Metador::Image::VipsScaler", process_time: Float}
        },
        _debug: {process_time: Float}
    }.merge(input)

    assert_matches_metador(input, expected)
  end
end
