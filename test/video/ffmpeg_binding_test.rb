require_relative '../test_helper'

class FfmpegBindingTest < FixturedTest

  it "should read meta of video" do

    fb = Metador::AudioVideo::FfmpegBinding.new
    result = fb.meta(File.join(@video_dir, 'tiny.mov'))

    assert result
    assert_equal 99, result.duration
  end

  it "should not read meta of non video file" do

    fb = Metador::AudioVideo::FfmpegBinding.new
    result = fb.meta(File.join(@document_dir, 'HallerVC07.pdf'))

    assert ! result

  end

end