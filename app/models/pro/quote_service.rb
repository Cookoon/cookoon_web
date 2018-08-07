module Pro
  class QuoteService < ApplicationRecord
    belongs_to :quote, class_name: 'Pro::Quote', foreign_key: 'pro_quote_id', inverse_of: :services

    enum category: %i[special catering chef corporate]

    validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  end
end
