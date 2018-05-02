module CardsHelper
  def price_display_for(cookoon)
    content = get_price_rank(cookoon.price_cents)
    content_tag(:div, content, class: ["hexagon", "ml-2"])
  end

  def category_display_for(cookoon)
    content = get_cookoon_icon_for(cookoon.category)
    content_tag(:div, content, class: "hexagon")
  end

  private

  def get_cookoon_icon_for(category)
    case category
    when 'Appartement'
      content_tag(:i, nil, class: 'far fa-building', aria: { hidden: true })
    when 'Jardin'
      content_tag(:i, nil, class: 'fas fa-tree', aria: { hidden: true })
    else
      content_tag(:i, nil, class: 'fas fa-home', aria: { hidden: true })
    end
  end

  def get_price_rank(price_cents)
    case price_cents
    when 0..3400 then '€'
    when 3500..4900 then '€€'
    else '€€€'
    end
  end
end
