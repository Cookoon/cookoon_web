require 'rails_helper'

RSpec.describe Motivation, type: :model do
  it 'is valid with a user, a content < 200 characters' do
    user = build(:user, :with_job, :with_personal_taste)
    motivation = build(:motivation, user: user)
    motivation.valid?
    expect(motivation).to be_valid
  end

  it 'is invalid without a user' do
    motivation = build(:personal_taste, user: nil)
    motivation.valid?
    expect(motivation.errors[:user]).to include('doit exister')
  end

  it 'is invalid without a content' do
    user = build(:user, :with_job, :with_personal_taste)
    motivation = build(:motivation, user: user, content: nil)
    motivation.valid?
    expect(motivation.errors[:content]).to include('doit être rempli(e)')
  end

  it 'is invalid with a content > 200 characters' do
    user = build(:user, :with_job, :with_personal_taste)
    motivation = build(:motivation, user: user, content: "Je suis un épicurien. Je suis un épicurien. Je suis un épicurien. Je suis un épicurien. Je suis un épicurien. Je suis un épicurien. Je suis un épicurien. Je suis un épicurien. Je suis un épicurien. Je suis un épicurien")
    motivation.valid?
    expect(motivation.errors[:content]).to include("est trop long (pas plus de 200 caractères)")
  end
end
