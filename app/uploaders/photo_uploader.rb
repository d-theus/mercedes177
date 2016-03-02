# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end


  version :thumb do
    process :watermark
    process resize_to_fill: [128, 96]
  end

  version :preview do
    process :watermark
    process resize_to_fit: [400, 300]
  end

  version :big do
    process :watermark
    process resize_to_fit: [2560, 1600]
  end

  def watermark
    manipulate! do |img|
      wm = MiniMagick::Image.open(File.join(Rails.root, 'app', 'assets', 'images', 'watermark.png'))
      size = "#{img.width / 3 - 20}x"
      offset = "+#{2*img.width / 3}+#{ 2*img.height/3}"
      img = img.composite(wm) do |c|
        c.compose 'Over'
        c.geometry "#{size}#{offset}"
      end
      img
    end
  end
end
