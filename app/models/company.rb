class Company < ApplicationRecord
  has_many :users, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :address, presence: true
  validates :siren, numericality: { only_integer: true }, length: { is: 9 }
  validates :siret, numericality: { only_integer: true }, length: { is: 14 }
  validates :vat, presence: true
end
