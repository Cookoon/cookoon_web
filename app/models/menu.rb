class Menu < ApplicationRecord

  STATUSES = %w[initial active archived].freeze
  MAX_PER_CHEF = 2

  belongs_to :chef
  has_many :reservations, dependent: :nullify
  has_many :dishes, dependent: :destroy

  monetize :unit_price_cents

  validates :description, presence: true
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validate :count_active_menus_per_chef?, if: :status_is_active?

  private

  def count_active_menus_per_chef?
    if chef&.reached_max_active_menus_count?
      errors.add(:status, :max_active_menus_count)
    end
  end

  def status_is_active?
    status == "active"
  end

end
