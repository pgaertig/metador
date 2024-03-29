require 'ffi'

module Metador
  module Util
    class MimeExtractor

      class Binding
        extend FFI::Library
        ffi_lib(%w(magic libmagic.so.1))
        attach_function :magic_open, [:int], :pointer
        attach_function :magic_load, [:pointer, :string], :int
        attach_function :magic_file, [:pointer, :string], :string
        attach_function :magic_close, [:pointer], :void

        MIME_TYPE = 0x000010


        def initialize
          @db = magic_open(MIME_TYPE)
          magic_load(@db, nil)
          ObjectSpace.define_finalizer(self) do
            magic_close @db
            @db = nil
          end
        end

        def mime(path)
          magic_file(@db, path)
        end
      end

      #Spawn once to prevent potential leaks
      BINDING = Binding.new

      def find_mime(path)
        BINDING.mime(path)
      end
    end
  end
end