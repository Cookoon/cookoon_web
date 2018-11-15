class Company < ApplicationRecord
  include Stripe::Customerable

  has_many :users, dependent: :restrict_with_exception
  has_many :quotes, class_name: 'Pro::Quote', dependent: :restrict_with_exception

  validates :name, presence: true
  validates :address, presence: true
  validates :siren, numericality: { only_integer: true }, length: { is: 9 }, allow_nil: true
  validates :siret, numericality: { only_integer: true }, length: { is: 14 }, allow_nil: true

  alias_attribute :to_s, :name
  alias_attribute :customerable_label, :name
end
