require 'rails_helper'

RSpec.describe Pro::Quote, type: :model do
  it 'has a valid factory' do
    quote = build(:pro_quote)
    expect(quote).to be_valid
  end

  it 'is invalid without a start date' do
    quote = build(:pro_quote, start_at: nil)
    quote.valid?
    expect(quote.errors).to include(:start_at)
  end

  it 'is invalid without a duration' do
    quote = build(:pro_quote, duration: nil)
    quote.valid?
    expect(quote.errors).to include(:duration)
  end

  it 'is invalid without a people count' do
    quote = build(:pro_quote, people_count: nil)
    quote.valid?
    expect(quote.errors).to include(:people_count)
  end
end
