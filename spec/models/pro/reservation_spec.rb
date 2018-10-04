require 'rails_helper'

RSpec.describe Pro::Reservation, type: :model do
  it 'has a valid factory' do
    reservation = build(:pro_reservation)
    expect(reservation).to be_valid
  end

  it 'is invalid without a start date' do
    reservation = build(:pro_reservation, start_at: nil)
    reservation.valid?
    expect(reservation.errors).to include(:start_at)
  end

  it 'is invalid without a duration' do
    reservation = build(:pro_reservation, duration: nil)
    reservation.valid?
    expect(reservation.errors).to include(:duration)
  end

  it 'is invalid without a people count' do
    reservation = build(:pro_reservation, people_count: nil)
    reservation.valid?
    expect(reservation.errors).to include(:people_count)
  end

  it { should delegate(:user).to(:quote) }
  it { should delegate(:company).to(:quote) }

  describe '#quote_reference' do
    it 'builds a formatted name for quote'
  end

  describe '#invoice_reference' do
    it 'builds a formatted name for invoice'
  end
end
