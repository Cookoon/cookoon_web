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
          when 'Appartement' then 'building'
          when 'Jardin' then 'tree'
          else 'home'
          end
    h.content_tag(:i, nil, class: "fas fa-#{cat}", aria: { hidden: true })
  end
end
