require 'rails_helper'

RSpec.describe Pro::Reservation::PriceComputer do
  describe '#computed_price_attributes' do
    let(:cookoon) { create(:cookoon, price_cents: 10000) }
    let(:reservation) { create(:pro_reservation, cookoon: cookoon, duration: 5, people_count: 5) }
    let!(:service) { create(:pro_service, reservation: reservation) }
    let(:prices) { reservation.computed_price_attributes }

    it 'returns a Hash' do
      expect(prices).to be_a(Hash)
    end

    it 'computes cookoon_price for duration with fees' do
      expect(prices[:cookoon_price]).to eq(Money.new 50000, 'EUR')
    end

    it 'computes cookoon_fee (fees taken on cookoon including VAT)' do
      expect(prices[:cookoon_fee]).to eq(Money.new 3500, 'EUR')
    end

    it 'computes cookoon_fee_tax (VAT amount on commission)' do
      expect(prices[:cookoon_fee_tax]).to eq(Money.new 583, 'EUR')
    end

    it 'computes services_price (sum of all options prices)' do
      expect(prices[:services_price]).to eq(Money.new 10000, 'EUR')
    end

    it 'computes services_tax (VAT on services)' do
      expect(prices[:services_tax]).to eq(Money.new 2000, 'EUR')
    end

    it 'computes services_full_price (Services prices plus fee plus tax)' do
      expect(prices[:services_full_price]).to eq(Money.new 12000, 'EUR')
    end

    it 'computes total_price (global price excluding tax)' do
      expect(prices[:total_price]).to eq(Money.new 62917, 'EUR')
    end

    it 'computes total_tax (total taxes)' do
      expect(prices[:total_tax]).to eq(Money.new 2583, 'EUR')
    end

    it 'computes price (global price)' do
      expect(prices[:total_full_price]).to eq(Money.new 65500, 'EUR')
    end
  end
end
