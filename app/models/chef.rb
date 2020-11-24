class Chef < ApplicationRecord
  has_many :menus
  has_many :chef_perks, dependent: :destroy
  has_many :chef_perk_specifications, through: :chef_perks

  has_attachments :photos, order: 'id ASC'
  has_attachment :main_photo

  default_scope -> { order(updated_at: :desc) }

  GENDER = %w[male female]

  validates :name, presence: true
  validates :description, presence: true
  validates :citation, presence: true
  validates :photos, presence: true, length: { minimum: 2, maximum: 10, message: "Vous devez télécharger au moins 2 photos et au plus 10 photos" }
  validates :main_photo, presence: true
  validates :base_price, numericality: { greater_than_or_equal_to: 0 }
  validates :min_price, numericality: { greater_than_or_equal_to: 0 }
  validates :gender, presence: true, inclusion: { in: GENDER }

  validate :base_price_or_min_price_positive

  monetize :base_price_cents
  monetize :min_price_cents

  # scope :has_active_menus, -> { where(id: Menu.where(status: "active").pluck(:chef_id)) }
  scope :has_active_seated_menus, -> { where(id: Menu.active.seated.pluck(:chef_id)) }
  scope :has_active_standing_menus, -> { where(id: Menu.active.standing.pluck(:chef_id)) }

  def base_price_or_min_price_positive
    if base_price.positive? && min_price.positive?
      errors.add(:base_price, "ne peut pas être positif si le prix minimum est positif")
      errors.add(:min_price, "ne peut pas être positif si le prix de prestation est positif")
    elsif base_price.zero? && min_price.zero?
      errors.add(:base_price, "ne peut pas être nul si le prix minimum est nul")
      errors.add(:min_price, "ne peut pas être nul si le prix de prestation est nul")
    end
  end

  def reached_max_active_menus_count?(meal_type)
    menus.active.where("meal_type = ?", meal_type).count >= Menu::MAX_PER_CHEF
  end

  def computed_min_price_with_margin
    compute_min_price_with_margin
  end

  def computed_min_price_with_margin_and_taxes
    compute_min_price_with_margin_and_taxes
  end

  def computed_base_price_with_margin
    compute_base_price_with_margin
  end

  def computed_base_price_with_margin_and_taxes
    compute_base_price_with_margin_and_taxes
  end

  def female?
    gender == "female"
  end

  def recap_string
    female? ? "La chef #{name}" : "Le chef #{name}"
  end

  private

  def compute_min_price_with_margin
    Money.new((1 + Reservation::MARGIN[:menu]) * self.min_price)
  end

  def compute_min_price_with_margin_and_taxes
    (1 + Reservation::TAX) * compute_min_price_with_margin
  end

  def compute_base_price_with_margin
    Money.new((1 + Reservation::MARGIN[:menu]) * self.base_price)
  end

  def compute_base_price_with_margin_and_taxes
    (1 + Reservation::TAX) * compute_base_price_with_margin
  end
end
