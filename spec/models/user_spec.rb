require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with a first name, last name, email and phone_number' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'is invalid without a first name' do
    user = build(:user, first_name: nil)
    user.valid?
    expect(user.errors).to include(:first_name)
  end

  it 'is invalid without a last name' do
    user = build(:user, last_name: nil)
    user.valid?
    expect(user.errors).to include(:last_name)
  end

  it 'is invalid without a phone number' do
    user = build(:user, phone_number: nil)
    user.valid?
    expect(user.errors).to include(:phone_number)
  end

  it 'returns a full name' do
    user = build(:user)
    expect(user.full_name).to eq('Aaron Sumner')
  end
end
