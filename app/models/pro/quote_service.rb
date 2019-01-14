module Pro
  class QuoteService < ApplicationRecord
    belongs_to :quote, class_name: 'Pro::Quote', foreign_key: 'pro_quote_id', inverse_of: :services

    enum category: %i[special catering chef corporate]

    validates :quantity, numericality: { only_integer: true, greater_than: 0 }


    def estimated_price_cents
      unit_price_cents * quantity
    end

    def unit_price_cents
      ::Service::PRICES.try(:[], category.to_sym).try(:[], :unit_price)
    end
  end
end
