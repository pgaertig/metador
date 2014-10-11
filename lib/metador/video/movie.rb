module Metador
  module Video
    class Movie

      pattr_initialize :meta

      def first_video_stream
        @first_video_stream ||= !video_streams.empty? && video_streams.first
      end

      def streams
        @streams ||= meta[:streams].collect { |s| Stream.new(s) }
      end

      def video_streams
        @video_streams ||= streams.select {|s| s.video? }
      end

      class Stream
        pattr_initialize :meta

        def duration
          meta[:duration].to_i
        end

        def width
          meta[:width].to_i
        end

        def height
          meta[:height].to_i
        end

        def video?
          meta[:codec_type] == 'video'
        end
      end


    end
  end
end