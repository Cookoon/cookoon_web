module NavbarCookoonComponent
  extend ComponentHelper
  property :type, default: :standard # :none

  def display_type
    @type.to_s
  end

  def notifications?
    notifiable_reservations? || notifiable_reservation_requests?
  end
end
