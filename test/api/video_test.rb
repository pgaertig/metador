require_relative '../metador_processor_test'

class VideoTest < MetadorProcessorTest

  it "thumbnails small video without upscaling" do
    input = {
        source_file: 'video/tiny.mov',
        query: {
            preview: {
                size: 70,
                destination_file: "generated/tiny.mov"
            },
            meta: true,
        }
    }

    expected = {
        mime: 'video/quicktime',
        preview: {
            width: 64, height: 36,
            destination_file: %w[
                generated/tiny.mov-01.jpg generated/tiny.mov-02.jpg generated/tiny.mov-03.jpg
            ],
            _debug: {scaler: "Metador::Video::PreviewProcessor"}

        }
    }.merge(input)

    assert_matches_metador(input, expected)
  end

  it "autoorient portrait video" do
    input = {
        source_file: 'video/portrait.mp4',
        query: {
            preview: {
                size: 160,
                destination_file: "generated/portrait.mp4"
            },
            meta: true,
        }
    }

    expected = {
        mime: 'video/mp4',
        preview: {
            width: 90, height: 160,
            destination_file: %w[
               generated/portrait.mp4-01.jpg generated/portrait.mp4-02.jpg generated/portrait.mp4-03.jpg
            ],
            _debug: {scaler: "Metador::Video::PreviewProcessor"}

        }
    }.merge(input)

    assert_matches_metador(input, expected)
  end

  it "scales landscape video" do
    input = {
        source_file: 'video/landscape.mp4',
        query: {
            preview: {
                size: 160,
                destination_file: "generated/landscape.mp4"
            },
            meta: true,
        }
    }

    expected = {
        mime: 'video/mp4',
        preview: {
            width: 160, height: 90,
            destination_file: %w[
                generated/landscape.mp4-01.jpg generated/landscape.mp4-02.jpg generated/landscape.mp4-03.jpg
            ],
            _debug: {scaler: "Metador::Video::PreviewProcessor"}
        }
    }.merge(input)

    assert_matches_metador(input, expected)
  end
end