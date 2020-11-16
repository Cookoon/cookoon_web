require 'rails_helper'

RSpec.describe PersonalTaste, type: :model do
  it 'is valid with a user, favorite_wines, favorite_restaurants' do
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

  it 'is invalid without favorite_wines' do
    user = build(:user, :with_job, :with_motivation)
    personal_taste = build(:personal_taste, user: user, favorite_wines: nil)
    personal_taste.valid?
    expect(personal_taste.errors[:favorite_wines]).to include('doit être rempli(e)')
  end

  it 'is invalid without a favorite_restaurants' do
    user = build(:user, :with_job, :with_motivation)
    personal_taste = build(:personal_taste, user: user, favorite_restaurants: nil)
    personal_taste.valid?
    expect(personal_taste.errors[:favorite_restaurants]).to include('doit être rempli(e)')
  end
end
