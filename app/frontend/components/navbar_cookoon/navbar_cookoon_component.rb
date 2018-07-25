module NavbarCookoonComponent
  extend ComponentHelper
  property :type, default: :menu # :logo, :back, :fixed_back, :none
  property :back_url

  def display_type
    @type.to_s
  end

  def back_link
    back_url? ? @back_url : 'javascript:history.back()'
  end

  def notifications?
    notifiable_reservations? || notifiable_reservation_requests?
  end

  def content_classes
    return 'content-padded-backlink' if back_nav_with_content?
    content? ? 'content-padded' : nil
  end

  def content?
    @content.present?
  end

  private

  def back_url?
    @back_url.present?
  end

  def back_nav?
    back? || fixed_back?
  end

  def back_nav_with_content?
    back? && content?
  end

  def back?
    @type == 'back'
  end

  def fixed_back?
    @type == 'fixed_back'
  end
end
