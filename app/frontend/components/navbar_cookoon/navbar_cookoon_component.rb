module NavbarCookoonComponent
  extend ComponentHelper
  property :type, default: :menu # :logo, :back, :fixed_back, :none
  property :back_url

  def display_type
    return 'back' if back_url? && not_fixed?
    @type.to_s
  end

  def back_link
    return @back_url if @back_url.present?
    'javascript:history.back()'
  end

  def notifications?
    notifiable_reservations? || notifiable_reservation_requests?
  end

  def content_classes
    return 'content-padded-backlink' if back_url? && content?
    content? ? 'content-padded' : nil
  end

  def not_fixed?
    @type != 'fixed_back'
  end

  def back_url?
    @back_url.present?
  end

  def content?
    @content.present?
  end
end
