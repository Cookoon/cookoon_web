class CookoonDecorator < Draper::Decorator
  include CloudinaryHelper
  delegate_all

  def photoswipe_slides
    photos.map do |photo|
      {
        src: cl_image_path(photo.path),
        w: photo.width,
        h: photo.height
      }
    end.to_json
  end

  def ideal_capacity
    return unless capacity
    "#{capacity} personnes <br \>en configuration dîner".html_safe
  end

  def ideal_capacity_standing
    return unless capacity_standing
    "#{capacity_standing} personnes <br \>en configuration cocktail".html_safe
  end

  def recommended_uses
    return unless object.recommended_uses
    <<-USES
      Ce lieu est recommandé pour :
      #{h.simple_format object.recommended_uses}
    USES
  end

  def perks_complement
    return unless object.perks_complement
    <<-PERKS
      Les plus :
      #{h.simple_format object.perks_complement}
    PERKS
  end

  def title_depending_on_reservation(reservation)
    if object.additionnal_address
      "#{reservation.humanized_type_name} #{object.additionnal_address}"
    else
      name
    end
  end
end
