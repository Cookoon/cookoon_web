class CookoonDecorator < Draper::Decorator
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
end
