class Service < ApplicationRecord
  belongs_to :reservation

  monetize :price_cents

  enum status: %i[quote paid]

  validates :content, presence: true
end
