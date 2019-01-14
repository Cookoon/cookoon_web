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

    enum status: %i[initial requested confirmed]

    after_save :report_to_slack, if: :saved_change_to_status?

    MAX_COOKOONS_COUNT = 2

    def estimated_price
      Money.new estimated_price_cents
    end

    private

    def estimated_price_cents
      services_price_cents = services.map { |service| service.estimated_price_cents }.sum
      cookoon_price_cents = (cookoons.sum(:price_cents) / MAX_COOKOONS_COUNT) * duration
      [services_price_cents, cookoon_price_cents].sum
    end

    def report_to_slack
      return unless Rails.env.production?
      PingSlackQuoteJob.perform_later(id) if requested?
    end
  end
end
