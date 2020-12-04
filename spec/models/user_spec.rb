require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with a first name, last name, email and phone_number, address, job, personal_taste, motivation, photo' do
    user = build(:user, :with_job, :with_personal_taste, :with_motivation)
    expect(user).to be_valid
  end

  # it 'is valid with a first name, last name, email and phone_number only if amex user' do
  #   user = build(:user, password: nil, address: nil, photo: nil, amex: true, skip_password_validation: true)
  #   expect(user).to be_valid
  # end

  it 'is invalid without a photo' do
    user = build(:user, :with_job, :with_personal_taste, :with_motivation)
    user.photo = nil
    user.valid?
    expect(user.errors[:photo]).to include('doit être rempli(e)')
  end

  it 'is invalid without a personal_taste' do
    user = build(:user, :with_job, :with_motivation)
    user.valid?
    expect(user.errors[:personal_taste]).to include('doit être rempli(e)')
  end

  it 'is invalid without a job' do
    user = build(:user, :with_personal_taste, :with_motivation)
    user.valid?
    expect(user.errors[:job]).to include('doit être rempli(e)')
  end

  it 'is invalid without a motivation' do
    user = build(:user, :with_job, :with_personal_taste)
    user.valid?
    expect(user.errors[:motivation]).to include('doit être rempli(e)')
  end

  it 'is invalid without a first name' do
    user = build(:user, :with_job, :with_personal_taste, :with_motivation, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include('doit être rempli(e)')
  end

  it 'is invalid without a last name' do
    user = build(:user, :with_job, :with_personal_taste, :with_motivation, last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include('doit être rempli(e)')
  end

  it 'is invalid without a phone number' do
    user = build(:user, :with_job, :with_personal_taste, :with_motivation, phone_number: nil)
    user.valid?
    expect(user.errors[:phone_number]).to include('doit être rempli(e)')
  end

  it 'is invalid with an invalid phone number' do
    user = build(:user, :with_job, :with_personal_taste, :with_motivation, phone_number: '06,2340')
    user.valid?
    expect(user.errors[:phone_number]).to include("n'est pas valide")
  end

  it 'returns a full name' do
    user = build(:user, :with_job, :with_personal_taste, :with_motivation)
    expect(user.full_name).to eq('Aaron Sumner')
  end
end
