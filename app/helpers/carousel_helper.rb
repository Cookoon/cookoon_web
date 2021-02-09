module CarouselHelper
  def carousel_for(images)
    Carousel.new(self, images).html
  end

  class Carousel
    def initialize(view, images)
      @view, @images = view, images
    end

    def html
      content = safe_join [wrapper, pagination, navigation_buttons]
      content_tag(
        :div,
        content,
        class: 'swiper-container carousel',
        data: { controller: 'swipers', target: 'swipers.swiperContainer' }
      )
    end

    private

    attr_accessor :view, :images
    # delegate :content_tag, :cl_image_path, :safe_join, to: :view
    delegate :content_tag, :cl_image_path, :safe_join, :image_url, to: :view

    def wrapper
      slides = images.map { |image| slide(image) }
      content_tag(:div, safe_join(slides), class: 'swiper-wrapper')
    end

    def slide(image)
      # image_url = cl_image_path(
      #   image.path,
      #   width: 800, height: 450, crop: :fill
      # )

      if image.class == String
        # renvoie l'url de l'image contenue dans la base
        image_full_url = image_url(image)
      else
        # renvoie l'url de l'image contenue dans cloudinary
        image_full_url = cl_image_path(
          image.path,
          # width: 800, height: 450, crop: :fill
        )
      end

      content_tag(
        :div,
        nil,
        class: 'swiper-slide',
          # style: "background-image:url(#{image_url})"
        style: "background-image:url(#{image_full_url})"
      )
    end

    def pagination
      content_tag(:div, nil, class: 'swiper-pagination')
    end

    def navigation_buttons
      safe_join [button('prev'), button('next')]
    end

    def button(navigation)
      # content_tag(:div, nil, class: "swiper-button-#{navigation} swiper-button-cookoon-blue d-none d-sm-block")
      # d-none removed because buttons were not displayed on phone
      content_tag(:div, nil, class: "swiper-button-#{navigation} swiper-button-cookoon-blue d-sm-block")
    end
  end
end
