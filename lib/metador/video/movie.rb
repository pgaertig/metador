module Metador
  module Video
    class Movie

      def initialize(ffmeta)
        streams = ffmeta[:streams].collect { |s| Stream.new(s) }
        video_streams = streams.select {|s| s.video? }
        audio_streams = streams.select {|s| s.audio? }
        first_video_stream = !video_streams.empty? && video_streams.first
        first_audio_stream = !audio_streams.empty? && audio_streams.first
        @meta_map = {}
        @meta_map.merge!(first_audio_stream.meta_map) if first_audio_stream
        @meta_map.merge!(first_video_stream.meta_map) if first_video_stream

        format = ffmeta[:format]
        if format
          @meta_map.merge!(
              {
                  duration: format[:duration]&.to_s&.to_i,
                  size: format[:size]&.to_s&.to_i,
                  creation_time: format[:tags]&.[](:creation_time)&.to_s,
                  format_name: format[:format_long_name]
              }.delete_if {| k, v | v.nil? }
          )
        end
      end

      def has_video?
        @meta_map[:video]
      end

      def has_audio?
        @meta_map[:audio]
      end

      def duration
        @meta_map[:duration]
      end

      def width
        @meta_map[:width]
      end

      def height
        @meta_map[:height]
      end

      def meta_map
        @meta_map
      end

      class Stream

        def initialize(ffmeta)
          @stream_meta = {
              duration: ffmeta[:duration]&.to_s&.to_i,
              width: ffmeta[:width]&.to_s&.to_i,
              height: ffmeta[:height]&.to_s&.to_i,
              creation_time: ffmeta[:tags]&.[](:creation_time)&.to_s
          }.delete_if {| k, v | v.nil? }

          if ffmeta[:codec_type] == 'video'
            @stream_meta.merge!(
                {
                    video: true,
                    video_frame_rate: ffmeta[:r_frame_rate]&.to_s,
                    video_codec: ffmeta[:codec_name]&.to_s,
                    video_codec_long: ffmeta[:codec_long_name]&.to_s,
                }.delete_if {| k, v | v.nil? }
            )
          end

          if ffmeta[:codec_type] == 'audio'
            @stream_meta.merge!(
                {
                    audio: true,
                    audio_codec: ffmeta[:codec_name]&.to_s,
                    audio_codec_long: ffmeta[:codec_long_name]&.to_s,
                    audio_sample_rate: ffmeta[:sample_rate]&.to_s&.to_i,
                }.delete_if {| k, v | v.nil? }
            )
          end
        end

        def meta_map
          @stream_meta
        end

        def video?
          @stream_meta[:video]
        end

        def audio?
          @stream_meta[:audio]
        end
      end


    end
  end
end