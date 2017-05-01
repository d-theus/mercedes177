# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_fit: [2560, 1600]

  version :thumb do
    process :watermark
    process resize_to_fill: [128, 96]
  end

  version :preview do
    process :watermark
    process resize_to_fit: [920, 700]
  end

  version :big do
    process :watermark
  end

  def watermark
    manipulate! do |img|
      wms = [
        MiniMagick::Image.open(File.join(Rails.root, 'app', 'assets', 'images', 'watermark.png')),
        MiniMagick::Image.open(File.join(Rails.root, 'app', 'assets', 'images', 'logo.png')),
      ]
      sizes = [
        "#{img.width / 3 - 20}x",
        "#{img.width / 10 }x",
      ]
      offsets = [
        "+#{2*img.width / 3}+#{ 2*img.height/3}",
        "+#{9*img.width/10 - 30}-#{50}",
      ]
      wms.each_with_index do |wm, i|
        img = img.composite(wm) do |c|
          c.compose 'Over'
          c.blend 50
          c.geometry "#{sizes[i]}#{offsets[i]}"
        end
      end
      img
    end
  end
end
