class Ephemeral < ApplicationRecord
  belongs_to :cookoon

  validates :title, presence: true
  validates :start_at, presence: true
  validates :duration, presence: true
  validates :people_count, presence: true
  validates :service_price, presence: true

  enum status: %i[inactive available unavailable]
end
