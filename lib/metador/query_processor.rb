class Metador::QueryProcessor < Metador::BaseProcessor
  IMAGE_EXT = "jpg,jpe,jpeg,tif,tiff,bmp,gif,png"
  VIDEO_EXT = "mpeg,mpg,avi,wmv,mov,flv,3gp,vob,m2ts,rmvb,mkv,mp4"
  OTHER_MAGICK_EXT = "pdf,cdr,ai,psd"

  def process(data, file_resolver:, preview_processor:)

    if data[:query]
      preview_processor.process(data, file_resolver: file_resolver)
    end
    data
  end
end