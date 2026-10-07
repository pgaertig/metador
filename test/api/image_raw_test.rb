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
        mime: 'image/x-nikon-nef', #that is bad really
        preview: {
            width: 401,
            height: 600,
            destination_file: 'generated/raw1-nef.jpg',
            _debug: {scaler: "Metador::Image::RawEmbeddedScaler", process_time: Float}
        },
        _debug: {process_time: Float}
    }.merge(input)

    assert_matches_metador(input, expected)
  end

  it "process raw CR3" do
    input = {
      source_file: 'image/raw2.CR3',
      query: {
        preview: {
          size: 600,
          destination_file: "generated/raw2-cr3"
        },
        meta: true,
      }
    }

    expected = {
      mime: 'image/x-canon-cr3', #that is bad really
      preview: {
        width: 600,
        height: 400,
        destination_file: 'generated/raw2-cr3.jpg',
        _debug: {scaler: "Metador::Image::RawEmbeddedScaler", process_time: Float}
      },
      _debug: {process_time: Float}
    }.merge(input)

    assert_matches_metador(input, expected)
  end

  it "process raw ARW" do
    input = {
      source_file: 'image/raw3.arw',
      query: {
        preview: {
          size: 600,
          destination_file: "generated/raw3-arw"
        },
        meta: true,
      }
    }

    expected = {
      mime: 'image/x-sony-arw', #that is bad really
      preview: {
        width: 600,
        height: 400,
        destination_file: 'generated/raw3-arw.jpg',
        _debug: {scaler: "Metador::Image::RawEmbeddedScaler", process_time: Float}
      },
      _debug: {process_time: Float}
    }.merge(input)

    assert_matches_metador(input, expected)
  end

  it "process Nikon High Efficiency* NEF" do
    input = {
      source_file: 'image/raw4-he.NEF',
      query: {
        preview: {
          size: 600,
          destination_file: "generated/raw4-he-nef"
        },
        meta: true,
      }
    }

    expected = {
      mime: 'image/x-nikon-nrw', # exiftool reports HE NEF as NRW, scaler picks it by extension
      preview: {
        width: 600,
        height: 400,
        destination_file: 'generated/raw4-he-nef.jpg',
        _debug: {scaler: "Metador::Image::RawEmbeddedScaler", process_time: Float}
      },
      _debug: {process_time: Float}
    }.merge(input)

    assert_matches_metador(input, expected)
  end
end
