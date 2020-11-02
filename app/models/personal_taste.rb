class PersonalTaste < ApplicationRecord
  belongs_to :user

  validates :favorite_champagne, presence: true
  validates :favorite_wine, presence: true
  validates :favorite_restaurant_one, presence: true
  validates :favorite_restaurant_two, presence: true
  validates :favorite_restaurant_three, presence: true
end
