require 'rails_helper'

RSpec.describe PerkSpecification, type: :model do
  it 'is valid with a name and icon_name' do
    perk_specification = build(:perk_specification)
    expect(perk_specification).to be_valid
  end

  it 'is invalid without a name' do
    perk_specification = build(:perk_specification, name: nil)
    perk_specification.valid?
    expect(perk_specification.errors[:name]).to include('doit être rempli(e)')
  end

  it 'is invalid without an icon_name' do
    perk_specification = build(:perk_specification, icon_name: nil)
    perk_specification.valid?
    expect(perk_specification.errors[:icon_name]).to include('doit être rempli(e)')
  end

  it 'is invalid if name is already taken' do
    create(:perk_specification)
    name_taken = build(:perk_specification)
    name_taken.valid?
    expect(name_taken.errors[:name]).to include("n'est pas disponible")
  end
end
