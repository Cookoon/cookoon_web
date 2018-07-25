module Pro
  class Quote < ApplicationRecord
    include EndAtSetter

    belongs_to :user
    belongs_to :company
    has_many :pro_quote_cookoons,
             class_name: 'Pro::QuoteCookoon', inverse_of: :pro_quote,
             foreign_key: :pro_quote_id, dependent: :destroy
    has_many :cookoons, through: :pro_quote_cookoons

    validates :start_at, presence: true
    validates :duration, numericality: { only_integer: true, greater_than: 0 }
    validates :people_count, numericality: { only_integer: true, greater_than: 0 }

    enum status: %i[initial request]
  end
end
