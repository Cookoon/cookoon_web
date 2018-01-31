class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :shuffled, -> { order("RANDOM()") }
end
