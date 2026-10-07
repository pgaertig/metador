require_relative 'test_helper'
require 'minitest/mock'

class WebHookProcessorTest < Minitest::Spec
  describe "WebHookProcessor" do
    before do
      @processor = Metador::WebHookProcessor.new(OpenStruct.new)
      @data = {source_file: 'a.jpg', mime: 'image/jpeg', exif: {'Make' => 'NIKON'}, webhook: 'http://kp.test/cb'}
    end

    it "leaves EXIF out of the webhook unless requested" do
      refute @processor.payload(@data.merge(query: {preview: {size: 100}})).key?(:exif)
      refute @processor.payload(@data).key?(:exif)
    end

    it "includes EXIF when query.exif is set" do
      payload = @processor.payload(@data.merge(query: {exif: true}))
      assert_equal({'Make' => 'NIKON'}, payload[:exif])
    end

    it "posts the payload as JSON to the webhook" do
      bodies = []
      request = Struct.new(:headers, :body) { def url(*) = nil }.new({}, nil)
      connection = Object.new
      connection.define_singleton_method(:post) { |&block| block.call(request); bodies << request.body }
      builder = Object.new
      def builder.response(*) = nil
      def builder.adapter(*) = nil
      Faraday.stub(:new, connection, builder) do
        @processor.process(@data.merge(query: {preview: {size: 100}}))
      end
      assert_equal 'application/json', request.headers['Content-Type']
      refute JSON.parse(bodies.first).key?('exif')
    end
  end
end
