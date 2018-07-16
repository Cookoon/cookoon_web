# frozen_string_literal: true

module ReservationCardComponent
  extend ComponentHelper

  attr_reader :reservation

  def title
    reservation.cookoon.name
  end

  def title_class
    case reservation.status
    when 'paid' then 'text-primary'
    when 'accepted', 'ongoing' then 'bg-primary text-white'
    else 'bg-secondary text-white'
    end
  end

  def image_url
    cl_image_path(reservation.cookoon.photos.first.path, width: 800, height: 450, crop: :fill)
  end

  def link_url
    case reservation.status
    when 'paid', 'accepted' then edit_reservation_path(reservation)
    when 'refused', 'passed', 'cancelled' then reservation_path(reservation)
    end
  end

  def infos
    content_tag :div do
      "#{display_datetime_for(reservation.start_at, without_year: true, join_expression: '· à')} · pour #{reservation.duration}h"
    end
  end
end
