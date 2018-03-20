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

  describe 'scopes' do
    let(:two_days_ago) { create(:reservation, created_at: 2.days.ago) }
    let(:paid) { create(:reservation, status: :paid) }
    let(:classic) { create(:reservation) }
    let(:short_notice) { create(:reservation, status: :paid, start_at: Time.zone.now.in(2.hours)) }

    describe '.dropped_before_payment' do
      it 'returns only pending reservations created more than few hours ago' do
        expect(Reservation.dropped_before_payment).to include(two_days_ago)
        expect(Reservation.dropped_before_payment).to_not include(paid, classic)
      end
    end

    describe '.short_notice' do
      it 'returns only paid reservations starting in less than few hours' do
        expect(Reservation.short_notice).to include(short_notice)
        expect(Reservation.short_notice).to_not include(paid, classic)
      end
    end
  end
end
