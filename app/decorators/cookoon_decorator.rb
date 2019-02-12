class CookoonDecorator < Draper::Decorator
  include CloudinaryHelper
  delegate_all

  def price_icon
    mark = case price_cents
           when 0..3400 then 1
           when 3500..4900 then 2
           else 3
           end
    h.content_tag(:i, nil, class: "co co-cookoon-mark#{mark}")
  end

  def category_icon
    cat = case category
          when 'Terrasse', 'Appartement', 'Toit' then 'flat'
          when 'Maison', 'Jardin', 'Villa' then 'house'
          when 'Loft' then 'loft'
          else 'flat'
          end
    h.content_tag(:i, nil, class: "co co-type-#{cat}", aria: { hidden: true })
  end

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
end
