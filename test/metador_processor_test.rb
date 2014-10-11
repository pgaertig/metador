require_relative 'test_helper'

class MetadorProcessorTest < FixturedTest

  before do
    @metador = Metador::MetadorProcessor.build(@config)
  end


  it "process jpeg image stored in dir" do
    data = {
        source_file: 'samples/IMG_2033.JPG',
        query: {
            preview: {
                size: 100,
                destination_file: "t1"
            },
            meta: true,
        }
    }

    result = @metador.process(data)

    assert_equal({
                     source_file: 'samples/IMG_2033.JPG',
                     query: {
                         preview: {
                             size: 100,
                             destination_file: "t1"
                         },
                         meta: true
                     },
                     mime: 'image/jpeg',
                     preview: {
                         width: 75,
                         height: 100,
                         destination_file: 't1.jpg'
                     }
                 }, result)
  end




  it "converts small video" do
    data = {
        source_file: 'samples/test1.mov',
        query: {
            preview: {
                size: 160,
                destination_file: "generated/t1"
            },
            meta: true,
        }
    }

    result = @metador.process(data)

    assert_equal({
                     source_file: 'samples/test1.mov',
                     query: {
                         preview: {
                             size: 160,
                             destination_file: "generated/t1"
                         },
                         meta: true
                     },
                     mime: 'video/quicktime',
                     preview: {
                         width: 128,
                         height: 72,
                         destination_file: ["generated/t1-01.jpg", "generated/t1-02.jpg", "generated/t1-03.jpg"]
                     }
                 }, result)
  end

  it "thumbnail small video to smaller" do
    data = {
        source_file: 'samples/test1.mov',
        query: {
            preview: {
                size: 64,
                destination_file: "generated/t1"
            },
            meta: true,
        }
    }

    result = @metador.process(data)

    assert_equal({
                     source_file: 'samples/test1.mov',
                     query: {
                         preview: {
                             size: 64,
                             destination_file: "generated/t1"
                         },
                         meta: true
                     },
                     mime: 'video/quicktime',
                     preview: {
                         width: 64,
                         height: 36,
                         destination_file: ["generated/t1-01.jpg", "generated/t1-02.jpg", "generated/t1-03.jpg"]
                     }
                 }, result)
  end


  it "converts pdf document" do
    data = {
        source_file: 'samples/HallerVC07.pdf',
        query: {
            preview: {
                size: 200,
                destination_file: "generated/t1"
            },
            meta: true,
        }
    }

    result = @metador.process(data)

    assert_equal({
                     source_file: 'samples/HallerVC07.pdf',
                     query: {
                         preview: {
                             size: 200,
                             destination_file: "generated/t1"
                         },
                         meta: true
                     },
                     mime: 'application/pdf',
                     preview: {
                         width: 155,
                         height: 200,
                         destination_file: 'generated/t1.jpg'
                     }
                 }, result)
  end
end