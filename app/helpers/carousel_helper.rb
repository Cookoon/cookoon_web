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
        class: 'swiper-container',
        data: { controller: 'swipers', target: 'swipers.swiperContainer' }
      )
    end

    private

    attr_accessor :view, :images
    delegate :content_tag, :cl_image_path, :safe_join, to: :view

    def wrapper
      slides = images.map { |image| slide(image) }
      content_tag(:div, safe_join(slides), class: 'swiper-wrapper')
    end

    def slide(image)
      image_url = cl_image_path(
        image.path,
        height: 600, width: 800, crop: :fill
      )

      content_tag(
        :div,
        nil,
        class: 'swiper-slide',
        style: "background-image:url(#{image_url})"
      )
    end

    def pagination
      content_tag(:div, nil, class: 'swiper-pagination')
    end

    def navigation_buttons
      safe_join [button('prev'), button('next')]
    end

    def button(navigation)
      content_tag(:div, nil, class: "swiper-button-#{navigation} swiper-button-cookoon-blue d-none d-sm-block")
    end
  end
end
