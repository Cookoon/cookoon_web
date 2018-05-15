module CookoonsHelper
  def cookoon_safe_picture(cookoon)
    cookoon.photos? ? cl_image_path(cookoon.photos.first.path) : 'https://lorempixel.com/400/200/city/'
  end

  def safe_picture_tag_for_reservations_index(cookoon)
    if cookoon.photos?
      cl_image_tag cookoon.photos.first.path, width: 150, height: 100, crop: "fit"
    else
      image_tag 'https://unsplash.it/150/100'
    end
  end

  def booking_button_or_review_block_for(cookoon)
    if cookoon.under_review?
      render 'under_review_card'
    else
      render 'reservation_button'
    end
  end
end
