module ReservationCardHelper
  def card_for(reservation)
    ReservationCard.new(self, reservation).html
  end

  class ReservationCard
    def initialize(view, reservation)
      @view, @reservation = view, reservation
      @user = @reservation.user
    end

    def html
      content = safe_join([infos, recap, button])
      content_tag(:div, content, class: "reservation-card #{color}")
    end

    private

    attr_accessor :view, :reservation, :user
    delegate :link_to, :content_tag, :image_tag, :cl_image_tag, :safe_join, to: :view

    def infos
      content = safe_join([user_picture, user_infos, status])
      content_tag(:div, content, class: 'reservation-card-infos')
    end

    def user_picture
      if user.photo?
        cl_image_tag(user.photo.path, { size: '50x50', crop: :thumb, gravity: :face, class: 'avatar-large' })
      else
        image_tag 'http://via.placeholder.com/50x50', class: 'avatar-large'
      end
    end

    def user_infos
      user_name = content_tag(:p, user.full_name, class: text_color)
      date = content_tag(:p, reservation.date)
      duration = content_tag(:p, "#{reservation.date.hour} . #{reservation.duration}")
      safe_join([user_name, date, duration])
    end

    def status
      case reservation.status
      when :paid
        content_tag(:i, nil, class: "co-reversed-meeting #{text_color}")
      when :accepted, :passed
        content_tag(:i, nil, class: 'co-reversed-check #{text_color}')
      when :refused
        content_tag(:i, nil, class: 'fa fa-times #{text_color}')
      end
    end

    def recap
      content = safe_join([user_rating, receive_text, price])
      content_tag(:div, content, class: 'reservation-card-recap')
    end

    def user_rating
      content_tag(:p, '100%')
    end

    def receive_text
      content_tag(:p, 'Vous recevrez :')
    end

    def price
      content_tag(:p, "#{reservation.price}  €", class: text_color)
    end

    def button
      content_tag(:div, button_tag, class: 'text-center')
    end

    def button_tag
      if reservation.paid?
        link_to('Répondre à la demande', edit_host_reservation_path(reservation), class: 'button button-blue')
      else
        #TODO: Edit path
        link_to('Voir la réservation', "", class: 'button button-white')
      end
    end
  end
end
