module Pro
  class Quote < ApplicationRecord
    include EndAtSetter

    belongs_to :user
    belongs_to :company
    has_many :quote_cookoons,
             class_name: 'Pro::QuoteCookoon', inverse_of: :quote,
             foreign_key: :pro_quote_id, dependent: :destroy
    has_many :cookoons, through: :quote_cookoons

    has_many :services,
             class_name: 'Pro::QuoteService', inverse_of: :quote,
             foreign_key: :pro_quote_id, dependent: :destroy

    has_many :reservations,
             class_name: 'Pro::Reservation', inverse_of: :quote,
             foreign_key: :pro_quote_id, dependent: :restrict_with_exception

    validates :start_at, presence: true
    validates :duration, numericality: { only_integer: true, greater_than: 0 }
    validates :people_count, numericality: { only_integer: true, greater_than: 0 }

    enum status: %i[initial request confirm]
  end
end
