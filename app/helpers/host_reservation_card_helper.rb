module HostReservationCardHelper
  def host_card_for(reservation)
    HostReservationCard.new(self, reservation).html
  end

  class HostReservationCard
    include Rails.application.routes.url_helpers

    def initialize(view, reservation)
      @view, @reservation = view, reservation
      @user = @reservation.user
    end

    def html
      content = safe_join([infos, recap, button])
      content_tag(:div, content, class: "reservation-preview-card reservation-preview-card-#{color}")
    end

    private

    attr_accessor :view, :reservation, :user
    delegate :link_to, :content_tag, :image_tag, :cl_image_tag, :safe_join, to: :view

    def infos
      content = safe_join([user_picture, user_infos, status])
      content_tag(:div, content, class: 'reservation-preview-card-infos')
    end

    def user_picture
      if user.photo?
        cl_image_tag(user.photo.path, { size: '80x80', crop: :thumb, gravity: :face, class: 'avatar-larger' })
      else
        image_tag 'http://via.placeholder.com/80x80', class: 'avatar-larger'
      end
    end

    def user_infos
      user_name = content_tag(:p, user.full_name)
      date = content_tag(:p, reservation.date.strftime('%d %B %Y'))
      duration = content_tag(:p, "#{reservation.date.hour}h pour #{reservation.duration}h")
      content = safe_join([user_name, date, duration])
      content_tag(:div, content, class: 'infos-block')
    end

    def status
      case reservation.status
      when 'paid'
        content_tag(:i, nil, class: "co co-reversed-meeting")
      when 'accepted', 'passed'
        content_tag(:i, nil, class: 'fa fa-check-circle-o')
      when 'refused'
        content_tag(:i, nil, class: 'fa fa-ban')
      end
    end

    def recap
      content = safe_join([user_rating, receive_text, price])
      content_tag(:div, content, class: 'reservation-preview-card-recap')
    end

    def user_rating
      content_tag(:p, '100%', id: 'force-margin')
    end

    def receive_text
      if reservation.passed?
        content_tag(:p, 'Vous avez reçu :')
      elsif reservation.refused?
        content_tag(:p, 'Vous auriez reçu :')
      else
        content_tag(:p, 'Vous recevrez :')
      end
    end

    def price
      content_tag(:p, "#{reservation.payout_price_for_host}  €", class: 'price')
    end

    def button
      content_tag(:div, button_tag, class: 'text-center light-padded')
    end

    def button_tag
      case reservation.status
      when 'paid'
        link_to('Répondre à la demande', edit_host_reservation_path(reservation), class: 'button button-blue')
      when 'accepted'
        #TODO: Edit path
        link_to('Voir la réservation', new_host_reservation_inventory_path(reservation), class: 'button button-white')
      when 'ongoing'
        link_to('Terminer la location', edit_host_inventory_path(reservation.inventory), class: 'button button-white')
      else
        # TODO : Add Host::Reservation#show
      end
    end

    def color
      case reservation.status
      when 'paid', 'ongoing' then 'white'
      when 'passed', 'refused' then 'grey'
      else 'blue'
      end
    end
  end
end
