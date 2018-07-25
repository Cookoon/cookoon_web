class Pro::Quote < ApplicationRecord
  include EndAtSetter

  belongs_to :user
  belongs_to :company

  validates :start_at, presence: true
  validates :duration, numericality: { only_integer: true, greater_than: 0 }
  validates :people_count, numericality: { only_integer: true, greater_than: 0 }

  enum status: %i[initial request]
end
