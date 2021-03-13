require_relative '../metador_processor_test'

class AudioMetaTest < MetadorProcessorTest

  it "meta for WMA file with MP3 stream" do
    input = {
        source_file: 'audio/sample.wma',
        query: {
            meta: true,
        }
    }

    expected = {
        mime: 'video/x-ms-asf',
        meta: {
            duration: 3,
            audio: true,
            audio_codec: "mp3",
            audio_codec_long: "MP3 (MPEG audio layer 3)",
            audio_sample_rate: 11025,
            audio_bit_rate: 64000,
            size: 32518,
            format_name: "asf",
            format_name_long: "ASF (Advanced / Active Streaming Format)"
        },
        _debug: {process_time: Float}
    }.merge(input)

    assert_matches_metador(input, expected)
  end

  it "meta for FLAC file" do
    input = {
        source_file: 'audio/sample.flac',
        query: {
            meta: true,
        }
    }

    expected = {
        mime: 'audio/flac',
        meta: {
            duration: 3,
            audio: true,
            audio_codec: "flac",
            audio_codec_long: "FLAC (Free Lossless Audio Codec)",
            audio_sample_rate: 11025,
            size: 68443,
            format_name: "flac",
            format_name_long: "raw FLAC"
        },
        _debug: {process_time: Float}
    }.merge(input)

    assert_matches_metador(input, expected)
  end
end