require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with a first name, last name, email and phone_number' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'is invalid without a first name' do
    user = build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include('doit être rempli(e)')
  end

  it 'is invalid without a last name' do
    user = build(:user, last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include('doit être rempli(e)')
  end

  it 'is invalid without a phone number' do
    user = build(:user, phone_number: nil)
    user.valid?
    expect(user.errors[:phone_number]).to include('doit être rempli(e)')
  end

  it 'is invalid with an invalid phone number' do
    user = build(:user, phone_number: '06,2340')
    user.valid?
    expect(user.errors[:phone_number]).to include("n'est pas valide")
  end

  it 'returns a full name' do
    user = build(:user)
    expect(user.full_name).to eq('Aaron Sumner')
  end
end
