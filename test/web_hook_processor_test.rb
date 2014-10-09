require_relative 'test_helper'

class WebHookProcessorTest < MiniTest::Spec
  describe "WebHookProcessor" do
    it "works" do
      skip "TBD"
      wh = Metador::WebHookProcessor.new
      wh.process({dupa: 123, callback: "http://kurierplikow.pl/api/items/123/previews"})
    end
  end
end