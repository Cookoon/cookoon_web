module Pro
  class QuoteCookoon < ApplicationRecord
    belongs_to :quote, class_name: 'Pro::Quote', foreign_key: :pro_quote_id
    belongs_to :cookoon
  end
end
