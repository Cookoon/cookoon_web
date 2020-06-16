class Chef < ApplicationRecord
  has_many :menus

  has_attachments :photos, maximum: 5, order: 'id ASC'

  validates :name, presence: true
  validates :description, presence: true
  validates :photos, presence: true
  validates_length_of :photos, minimum: 2, maximum: 5, message: "Vous devez télécharger au moins 2 photos et au plus 5 photos"
  validates :base_price, numericality: { greater_than_or_equal_to: 0 }
  validates :min_price, numericality: { greater_than_or_equal_to: 0 }

  validate :base_price_or_min_price_positive

  monetize :base_price_cents
  monetize :min_price_cents

  def base_price_or_min_price_positive
    if base_price.positive? && min_price.positive?
      errors.add(:base_price, "ne peut pas être positif si le prix minimum est positif")
      errors.add(:min_price, "ne peut pas être positif si le prix de prestation est positif")
    elsif base_price.zero? && min_price.zero?
      errors.add(:base_price, "ne peut pas être nul si le prix minimum est nul")
      errors.add(:min_price, "ne peut pas être nul si le prix de prestation est nul")
    end
  end

  def reached_max_active_menus_count?
    menus.where(status: "active").count > Menu::MAX_PER_CHEF
  end
end
