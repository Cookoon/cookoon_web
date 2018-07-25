module Pro
  class QuoteCookoon < ApplicationRecord
    belongs_to :pro_quote, class_name: 'Pro::Quote'
    belongs_to :cookoon
  end
end
