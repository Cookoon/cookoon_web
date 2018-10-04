require 'rails_helper'

RSpec.describe Company, type: :model do
  it 'has a valid factory' do
    company = build(:company)
    expect(company).to be_valid
  end

  it 'is invalid without a valid siren' do
    company = build(:company, :with_invalid_siren)
    company.valid?
    expect(company.errors).to include(:siren)
  end

  it 'is invalid without a valid siret' do
    company = build(:company, :with_invalid_siret)
    company.valid?
    expect(company.errors).to include(:siret)
  end

  it 'is invalid without a name' do
    company = build(:company, name: nil)
    company.valid?
    expect(company.errors).to include(:name)
  end

  it 'is invalid  without an address' do
    company = build(:company, address: nil)
    company.valid?
    expect(company.errors).to include(:address)
  end
end
