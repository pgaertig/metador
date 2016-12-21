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
            _debug: {scaler: "Metador::Video::PreviewProcessor", process_time: Float},
        },
        meta: {
            duration: 99,
            width: 64,
            height: 36,
            video: true,
            video_frame_rate: "30/1",
            video_codec: "h264",
            video_codec_long: "H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10",
            size: 446614,
            format_name: "QuickTime / MOV"
        },
        _debug: {process_time: Float}
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
            _debug: {scaler: "Metador::Video::PreviewProcessor", process_time: Float}

        },
        meta: {
            duration: 74,
            width: 1920,
            height: 1080,
            audio: true,
            audio_codec: "aac",
            audio_codec_long: "AAC (Advanced Audio Coding)",
            audio_sample_rate: 48000,
            video: true,
            video_frame_rate: "30/1",
            video_codec: "h264",
            video_codec_long: "H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10",
            size: 160394452,
            format_name: "QuickTime / MOV",
            creation_time: "2016-10-05T15:48:09.000000Z"
        },
        _debug: {process_time: Float}
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
            _debug: {scaler: "Metador::Video::PreviewProcessor", process_time: Float},
        },
        meta: {
            duration: 81,
            width: 1920,
            height: 1080,
            audio: true,
            audio_codec: "aac",
            audio_codec_long: "AAC (Advanced Audio Coding)",
            audio_sample_rate: 48000,
            video: true,
            video_frame_rate: "30/1",
            video_codec: "h264",
            video_codec_long: "H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10",
            size: 176218966,
            format_name: "QuickTime / MOV",
            creation_time: "2016-08-25T12:21:09.000000Z"
        },
        _debug: {process_time: Float}
    }.merge(input)

    assert_matches_metador(input, expected)
  end
end