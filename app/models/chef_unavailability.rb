class ChefUnavailability < Unavailability
  belongs_to :chef

  validates :chef, uniqueness: { scope: %i[date time_slot] }
end
