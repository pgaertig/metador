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
                destination_file: "generated/t1metador"
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
                             destination_file: "generated/t1metador"
                         },
                         meta: true
                     },
                     mime: 'image/jpeg',
                     preview: {
                         width: 75,
                         height: 100,
                         destination_file: 'generated/t1metador.jpg',
                         "_debug"=>{:scaler=>"Metador::Image::VipsScaler"}
                     }
                 }, result)
  end




  it "converts small video" do
    data = {
        source_file: 'samples/test1.mov',
        query: {
            preview: {
                size: 160,
                destination_file: "generated/t2metador"
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
                             destination_file: "generated/t2metador"
                         },
                         meta: true
                     },
                     mime: 'video/quicktime',
                     preview: {
                         width: 64,
                         height: 36,
                         destination_file: ["generated/t2metador-01.jpg", "generated/t2metador-02.jpg", "generated/t2metador-03.jpg"]
                     }
                 }, result)
  end

  it "thumbnail small video to smaller" do
    data = {
        source_file: 'samples/test1.mov',
        query: {
            preview: {
                size: 35,
                destination_file: "generated/t3metador"
            },
            meta: true,
        }
    }

    result = @metador.process(data)

    assert_equal({
                     source_file: 'samples/test1.mov',
                     query: {
                         preview: {
                             size: 35,
                             destination_file: "generated/t3metador"
                         },
                         meta: true
                     },
                     mime: 'video/quicktime',
                     preview: {
                         width: 35,
                         height: 19,
                         destination_file: ["generated/t3metador-01.jpg", "generated/t3metador-02.jpg", "generated/t3metador-03.jpg"]
                     }
                 }, result)
  end


  it "converts pdf document" do
    data = {
        source_file: 'samples/HallerVC07.pdf',
        query: {
            preview: {
                size: 200,
                destination_file: "generated/t1pdf"
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
                             destination_file: "generated/t1pdf"
                         },
                         meta: true
                     },
                     mime: 'application/pdf',
                     preview: {
                         width: 155,
                         height: 200,
                         destination_file: 'generated/t1pdf.jpg',
                         "_debug"=>{:scaler=>"Metador::Image::MagickScaler"}
                     }
                 }, result)
  end

  it "process raw NEF" do
    data = {
        source_file: 'samples/raw/raw_nef_1.NEF',
        query: {
            preview: {
                size: 600,
                destination_file: "generated/t1raw"
            },
            meta: true,
        }
    }

    result = @metador.process(data)

    assert_equal(
        {
          source_file: 'samples/raw/raw_nef_1.NEF',
          query: {
            preview: {
              size: 600,
              destination_file: "generated/t1raw"
            },
            meta: true
          },
          mime: 'image/tiff', #that is bad really
          preview: {
            width: 401,
            height: 600,
            destination_file: 'generated/t1raw.jpg',
            "_debug"=>{:scaler=>"Metador::Image::MagickScaler"}
          }
        }, result)
  end
end