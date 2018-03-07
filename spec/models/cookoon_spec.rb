require 'rails_helper'

RSpec.describe Cookoon, type: :model do
  it 'is valid with a user, name, surface, price, address, capacity, category and photos' do
    cookoon = build(:cookoon)
    expect(cookoon).to be_valid
  end

  it 'is invalid without a user' do
    cookoon = build(:cookoon, user: nil)
    cookoon.valid?
    expect(cookoon.errors[:user]).to include('doit exister')
  end

  it 'is invalid without a name' do
    cookoon = build(:cookoon, name: nil)
    cookoon.valid?
    expect(cookoon.errors[:name]).to include('doit être rempli(e)')
  end

  it 'is invalid without a surface' do
    cookoon = build(:cookoon, surface: nil)
    cookoon.valid?
    expect(cookoon.errors[:surface]).to include('doit être rempli(e)')
  end

  it 'is invalid without a address' do
    cookoon = build(:cookoon, address: nil)
    cookoon.valid?
    expect(cookoon.errors[:address]).to include('doit être rempli(e)')
  end

  it 'is invalid without a capacity' do
    cookoon = build(:cookoon, capacity: nil)
    cookoon.valid?
    expect(cookoon.errors[:capacity]).to include('doit être rempli(e)')
  end

  it 'is invalid without a category' do
    cookoon = build(:cookoon, category: nil)
    cookoon.valid?
    expect(cookoon.errors[:category]).to include('doit être rempli(e)')
  end

  context 'is invalid with a price' do
    it 'blank' do
      cookoon = build(:cookoon, price: nil)
      cookoon.valid?
      expect(cookoon.errors[:price]).to include('doit être supérieur à 0')
    end

    it 'equal to 0' do
      cookoon = build(:cookoon, price: 0)
      cookoon.valid?
      expect(cookoon.errors[:price]).to include('doit être supérieur à 0')
    end

    it 'less than 0' do
      cookoon = build(:cookoon, price: -100)
      cookoon.valid?
      expect(cookoon.errors[:price]).to include('doit être supérieur à 0')
    end
  end
end
