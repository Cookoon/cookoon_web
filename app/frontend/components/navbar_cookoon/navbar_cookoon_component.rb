module NavbarCookoonComponent
  extend ComponentHelper
  property :type, default: :menu # :back, :fixed_back, :none
  property :back_url

  def display_type
    if @back_url.blank?
      @type
    else
      @type == :menu ? :back : @type
    end.to_s
  end

  def back_link
    return @back_url if @back_url.present?
    'javascript:history.back()'
  end

  def notifications?
    notifiable_reservations? || notifiable_reservation_requests?
  end
end
