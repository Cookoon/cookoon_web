class Perk < ApplicationRecord
  belongs_to :cookoon
  belongs_to :perk_specification

  delegate :name, :icon_name, to: :perk_specification, allow_nil: true

  scope :equipements, -> { includes(:perk_specification).where(perk_specifications: { name: PerkSpecification::EQUIPEMENTS }) }
  scope :access, -> { includes(:perk_specification).where(perk_specifications: { name: PerkSpecification::ACCESS }) }
  scope :unusuals, -> { includes(:perk_specification).where(perk_specifications: { name: PerkSpecification::UNUSUALS }) }

  validates :perk_specification, presence: true, uniqueness: { scope: [:cookoon] }

end
