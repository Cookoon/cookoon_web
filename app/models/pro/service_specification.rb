module Pro
  class ServiceSpecification < ApplicationRecord
    validates :name, presence: true

    monetize :unit_price_cents
  end
end
