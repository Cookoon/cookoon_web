require 'rails_helper'

RSpec.describe Reservation, type: :model do
  it 'has a valid factory' do
    reservation = build(:reservation)
    expect(reservation).to be_valid
  end

  it 'is invalid without a start date' do
    reservation = build(:reservation, start_at: nil)
    reservation.valid?
    expect(reservation.errors[:start_at]).to include('doit être rempli(e)')
  end

  it 'is invalid without a duration' do
    reservation = build(:reservation, duration: nil)
    reservation.valid?
    expect(reservation.errors[:duration]).to include('doit être rempli(e)')
  end

  describe '.dropped_before_payment' do
    it 'returns pending reservations created more than few hours ago' do
    end
  end
end
