class Service < ApplicationRecord
  belongs_to :reservation

  delegate :cookoon, :user, to: :reservation

  monetize :price_cents
  monetize :discount_amount_cents
  monetize :charge_amount_cents

  enum status: %i[quote paid]

  validates :content, presence: true

  def discount_used?
    discount_amount_cents.positive?
  end

  def charge_amount_cents
    price_cents - discount_amount_cents
  end

  class Payment
    include Stripe::Chargeable

    attr_reader :service, :options

    delegate :user, :charge_amount_cents, :cookoon, to: :service
    delegate :stripe_customer, to: :user

    alias_attribute :chargeable, :service

    def initialize(service, options = {})
      @service = service
      @options = options
    end

    def should_capture?
      true
    end

    def description
      "Paiement des services pour #{cookoon.name}"
    end
  end
end
