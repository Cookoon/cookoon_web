module Pro
  class QuoteService < ApplicationRecord
    belongs_to :quote, class_name: 'Pro::Quote', foreign_key: 'pro_quote_id'

    enum category: %i[special catering chef corporate]
  end
end
