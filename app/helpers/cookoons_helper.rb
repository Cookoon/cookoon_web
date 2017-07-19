module CookoonsHelper
  def readable_price(cookoon)
    humanized_money_with_symbol cookoon.price
  end

  def cookoon_safe_picture(cookoon)
    cookoon.photos? ? "https://res.cloudinary.com/cookoon/image/upload/#{cookoon.photos.first.path}" : 'http://lorempixel.com/400/200/city/'
  end

  def safe_picture_tag_for_reservations_index(cookoon)
    if cookoon.photos?
      cl_image_tag cookoon.photos.first.path, width: 150, height: 100, crop: "fit"
    else
      image_tag 'https://unsplash.it/150/100'
    end
  end
end
