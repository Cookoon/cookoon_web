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

  context 'Money Rails' do
    it { is_expected.to monetize(:cookoon_price) }
    it { is_expected.to monetize(:cookoon_fee) }
    it { is_expected.to monetize(:cookoon_fee_tax) }
    it { is_expected.to monetize(:services_price) }
    it { is_expected.to monetize(:services_tax) }
    it { is_expected.to monetize(:services_full_price) }
    it { is_expected.to monetize(:total_price) }
    it { is_expected.to monetize(:total_tax) }
    it { is_expected.to monetize(:total_full_price) }
  end

  context 'Formating' do
    let(:reservation) { create(:pro_reservation) }

    describe '#quote_reference' do
      it 'returns a formatted name for quote' do
        expect(reservation.quote_reference).to match(/DEV-C4B-\d{7,}/)
      end
    end

    describe '#invoice_reference' do
      it 'returns a formatted name for invoice' do
        expect(reservation.invoice_reference).to match(/FAC-C4B-\d{7,}/)
      end
    end

    describe '#ical_file_name' do
      it 'returns a formatted name for ical file' do
        expect(reservation.ical_file_name).to match(/\w*.ics/)
      end
    end
  end

  describe 'scopes' do
    let(:draft) { create(:pro_reservation, :draft) }
    let(:proposed) { create(:pro_reservation, :proposed) }
    let(:modification_requested) { create(:pro_reservation, :modification_requested) }
    let(:accepted) { create(:pro_reservation, :accepted) }
    let(:passed) { create(:pro_reservation, :passed) }


    describe '.engaged' do
      let(:tested_scope) { described_class.engaged }

      it 'returns only pending reservations created more than few hours ago' do
        expect(tested_scope).to include(proposed, modification_requested, accepted)
        expect(tested_scope).to_not include(draft, passed)
      end
    end
  end
end
