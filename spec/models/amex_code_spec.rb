require 'rails_helper'

RSpec.describe AmexCode, type: :model do
  it 'is valid with a code and e-mail' do
    amex_code = build(:amex_code)
    expect(amex_code).to be_valid
  end

  it 'is invalid without a code' do
    amex_code = build(:amex_code, code: '')
    amex_code.valid?
    expect(amex_code.errors[:code]).to include('doit être rempli(e)')
  end

  it 'is invalid without e-mail' do
    amex_code = build(:amex_code, email: '')
    amex_code.valid?
    expect(amex_code.errors[:email]).to include('doit être rempli(e)')
  end

  it 'is invalid if code is already taken' do
    create(:amex_code)
    code_taken = build(:amex_code)
    code_taken.valid?
    code_taken.save
    expect(code_taken.errors[:code]).to include("n'est pas disponible")
  end

  it 'is invalid if code is less than 8 characters' do
    amex_code = build(:amex_code, code: 'la')
    amex_code.valid?
    expect(amex_code.errors[:code]).to include("ne fait pas la bonne longueur (doit comporter 8 caractères)")
  end

  it 'is invalid if code is more than 8 characters' do
    amex_code = build(:amex_code, code: 'lalalalalalalala')
    amex_code.valid?
    expect(amex_code.errors[:code]).to include("ne fait pas la bonne longueur (doit comporter 8 caractères)")
  end

  # context 'user already has amex code' do
  #   let(:user) { create(:user, :with_job, :with_personal_taste, :with_motivation)}

  #   it 'is valid when user has no amex_code' do
  #     amex_code = create(:amex_code, user: user)
  #     expect(amex_code).to be_valid
  #   end

  #   it 'is invalid when user has one amex code' do
  #     create(:amex_code, user: user)
  #     amex_code = build(:amex_code, code: 'zertyuiopqsd', user: user)
  #     amex_code.valid?
  #     expect(amex_code.errors[:user]).to include("n'est pas disponible")
  #   end
  # end
end
