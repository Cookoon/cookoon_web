module HostReservationCardHelper
  def host_card_for(reservation)
    HostReservationCard.new(self, reservation).html
  end

  class HostReservationCard
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::TranslationHelper
    include DatetimeHelper

    def initialize(view, reservation)
      @view, @reservation = view, reservation
      @user = @reservation.user
    end

    def html
      content = safe_join([infos, recap, button, cancel_instructions])
      content_tag(:div, content, class: "reservation-preview-card reservation-preview-card-#{color}")
    end

    private

    attr_accessor :view, :reservation, :user
    delegate :link_to, :mail_to, :content_tag, :image_tag, :cl_image_tag, :safe_join, to: :view

    def infos
      content = safe_join([user_picture, user_infos, status])
      content_tag(:div, content, class: 'reservation-preview-card-infos')
    end

    def user_picture
      if user.photo?
        cl_image_tag(user.photo.path, { size: '80x80', crop: :thumb, gravity: :face, class: 'avatar-larger' })
      else
        image_tag 'base_user.png', class: 'avatar-larger'
      end
    end

    def user_infos
      user_name = content_tag(:p, user.full_name)
      date = content_tag(:p, display_date_for(reservation.date))
      duration = content_tag(:p, "#{display_time_for(reservation.date)} pour #{reservation.duration}h")
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
      # UnComment when reviews are implemented
      # content_tag(:p, '100%', id: 'force-margin')
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
        link_to('Démarrer la location', new_host_reservation_inventory_path(reservation), class: 'button button-white')
      when 'ongoing'
        link_to('Terminer la location', edit_host_inventory_path(reservation.inventory), class: 'button button-white')
      else
        # TODO : Add Host::Reservation#show
      end
    end

    def cancel_instructions
      return unless reservation.accepted?
      content = safe_join([cancel_text, cancel_link])
      content_tag(:div, content, class: 'text-center mt-20')
    end

    def cancel_text
      content_tag(:p, 'Un imprévu ? Pour annuler cette réservation :')
    end

    def cancel_link
      mail_to(
        'concierge@cookoon.fr',
        'contactez notre équipe',
        class: 'no-button no-button-white',
        subject: 'Annulation de réservation',
        body: cancel_mailer_body
      )
    end

    def cancel_mailer_body
      str = "Demande d'annulation pour la réservation n°#{reservation.id} \n"
      str << "Prévue pour le #{display_datetime_for(reservation.date, join_expression: 'à')}"
      str
    end

    def color
      case reservation.status
      when 'paid' then 'white'
      when 'passed', 'refused' then 'grey'
      else 'blue'
      end
    end
  end
end
