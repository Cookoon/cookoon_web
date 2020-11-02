require 'rails_helper'

RSpec.describe PersonalTaste, type: :model do
  it 'is valid with a user, a favorite_champagne, a favorite_wine, a favorite_restaurant_one, a favorite_restaurant_two, a favorite_restaurant_three' do
      user = build(:user, :with_job, :with_motivation)
      personal_taste = build(:personal_taste, user: user)
      personal_taste.valid?
      expect(personal_taste).to be_valid
    end

    it 'is invalid without a user' do
      personal_taste = build(:personal_taste, user: nil)
      personal_taste.valid?
      expect(personal_taste.errors[:user]).to include('doit exister')
    end

    it 'is invalid without a favorite_champagne' do
      user = build(:user, :with_job, :with_motivation)
      personal_taste = build(:personal_taste, user: user, favorite_champagne: nil)
      personal_taste.valid?
      expect(personal_taste.errors[:favorite_champagne]).to include('doit être rempli(e)')
    end

    it 'is invalid without a favorite_wine' do
      user = build(:user, :with_job, :with_motivation)
      personal_taste = build(:personal_taste, user: user, favorite_wine: nil)
      personal_taste.valid?
      expect(personal_taste.errors[:favorite_wine]).to include('doit être rempli(e)')
    end

    it 'is invalid without a favorite_restaurant_one' do
      user = build(:user, :with_job, :with_motivation)
      personal_taste = build(:personal_taste, user: user, favorite_restaurant_one: nil)
      personal_taste.valid?
      expect(personal_taste.errors[:favorite_restaurant_one]).to include('doit être rempli(e)')
    end

    it 'is invalid without a favorite_restaurant_two' do
      user = build(:user, :with_job, :with_motivation)
      personal_taste = build(:personal_taste, user: user, favorite_restaurant_two: nil)
      personal_taste.valid?
      expect(personal_taste.errors[:favorite_restaurant_two]).to include('doit être rempli(e)')
    end

    it 'is invalid without a favorite_restaurant_three' do
      user = build(:user, :with_job, :with_motivation)
      personal_taste = build(:personal_taste, user: user, favorite_restaurant_three: nil)
      personal_taste.valid?
      expect(personal_taste.errors[:favorite_restaurant_three]).to include('doit être rempli(e)')
    end
end
