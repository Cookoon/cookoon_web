module EphemeralsHelper
  def ephemeral_safe_picture(ephemeral)
    cloudinary_url = ephemeral.cover_picture_url ? ephemeral.cover_picture_url : "default_ephemeral#{rand(1..4)}.jpg"
    cl_image_path(cloudinary_url, width: 800, height: 450, crop: :fill)
  end
end
