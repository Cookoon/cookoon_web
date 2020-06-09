class Chef < ApplicationRecord
  has_many :menus

  has_attachments :photos, maximum: 5, order: 'id ASC'

  validates :name, presence: true
  validates :description, presence: true
  validates :photos, presence: true

  monetize :base_price_cents
  monetize :min_price_cents
end
