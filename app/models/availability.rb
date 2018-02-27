class Availability < ApplicationRecord
  belongs_to :cookoon

  enum time_slot: %i[morning noon afternoon evening]
end
