module CreditCardsHelper
  def credit_card_label_for(stripe_card)
    "#{brand_for(stripe_card).upcase} #{safe_number_for stripe_card}"
  end

  def render_credit_card_for(stripe_card)
    "<i class='fab fa-cc-#{brand_for(stripe_card).downcase}'></i> #{safe_number_for stripe_card}".html_safe
  end

  private

  def brand_for(stripe_card)
    return 'Amex' if stripe_card.card.brand == 'American Express'
    stripe_card.card.brand
  end

  def safe_number_for(stripe_card)
    "•••• #{stripe_card.card.last4}"
  end
end
