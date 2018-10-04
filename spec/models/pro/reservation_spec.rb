require 'rails_helper'

RSpec.describe Pro::Reservation, type: :model do
  it 'has a valid factory' do
    reservation = build(:pro_reservation)
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

  it { should delegate(:user).to(:quote) }

  it { should delegate(:company).to(:quote) }
end
