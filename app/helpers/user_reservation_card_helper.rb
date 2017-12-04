module UserReservationCardHelper
  def user_card_for(reservation)
    UserReservationCard.new(self, reservation).html
  end

  class UserReservationCard
    include Rails.application.routes.url_helpers

    def initialize(view, reservation)
      @view, @reservation = view, reservation
    end

    def html
      content = safe_join([header, picture])
      link_to reservation_link do
        content_tag(:div, content, class: "user-reservation-card user-reservation-card-#{color}")
      end
    end

    private

    attr_accessor :view, :reservation
    delegate :link_to, :content_tag, :image_tag, :cl_image_tag, :safe_join, :safe_picture_tag_for_reservations_index, :cl_image_path, :display_datetime_for, to: :view

    def header
      content = safe_join([header_infos, header_status])
      content_tag(:div, content, class: 'user-reservation-card-header')
    end

    def header_infos
      content = safe_join([title, details])
      content_tag(:div, content, class: 'user-reservation-card-header-infos')
    end

    def title
      content_tag(:h4, "#{reservation.cookoon.name}")
    end

    def details
      content_tag(:p, "#{display_datetime_for(reservation.date, join_expression: '. à')} . pour #{reservation.duration}h")
    end

    def header_status
      case reservation.status
      when 'paid'
        content_tag(:i, nil, class: "co co-reversed-meeting")
      when 'accepted', 'passed'
        content_tag(:i, nil, class: 'fa fa-check-circle-o')
      when 'refused'
        content_tag(:i, nil, class: 'fa fa-ban')
      end
    end

    def picture
      content_tag(:div, nil, class: 'user-reservation-card-picture', style: "background-image: url(#{cl_image_path reservation.cookoon.photos.first.path})")
    end


    def color
      case reservation.status
      when 'paid' then 'white'
      when 'accepted' then 'blue'
      else 'grey'
      end
    end

    def reservation_link
      case reservation.status
      when 'paid', 'accepted' then edit_reservation_path(reservation)
      when 'refused', 'passed', 'cancelled' then reservation_path(reservation)
      end
    end
  end
end
