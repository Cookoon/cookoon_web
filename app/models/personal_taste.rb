class PersonalTaste < ApplicationRecord
  belongs_to :user

  validates :favorite_wines, presence: true
  validates :favorite_restaurants, presence: true
end
