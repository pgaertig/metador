require_relative '../test_helper'

class FfmpegBindingTest < FixturedTest

  it "should read meta of video" do

    fb = Metador::Video::FfmpegBinding.new
    result = fb.meta(File.join(@video_dir, 'tiny.mov'))

    assert result
    assert result.first_video_stream
    p result.first_video_stream
  end

  it "should not read meta of non video file" do

    fb = Metador::Video::FfmpegBinding.new
    result = fb.meta(File.join(@document_dir, 'HallerVC07.pdf'))

    assert ! result

  end

end