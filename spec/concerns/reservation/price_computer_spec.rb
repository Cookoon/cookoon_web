require 'rails_helper'

RSpec.describe Reservation::PriceComputer do
  describe '#computed_price_attributes' do
    let(:cookoon) { create(:cookoon, price_cents: 9000) }
    let(:reservation) { create(:reservation, cookoon: cookoon, people_count: 10, type_name: 'breakfast', category: 'business') }
    let!(:service) { create(:service, reservation: reservation, category: 'breakfast') }
    let!(:service) { create(:service, reservation: reservation, category: 'corporate') }
    let(:prices) { reservation.computed_price_attributes }

    it 'returns a Hash' do
      expect(prices).to be_a(Hash)
    end

    it 'computes cookoon_price for duration with fees' do
      expect(prices[:cookoon_price]).to eq(Money.new 27000, 'EUR')
    end

    it 'computes services_price (sum of all options prices)' do
      expect(prices[:services_price]).to eq(Money.new 127900, 'EUR')
    end

    it 'computes services_tax (VAT on services)' do
      expect(prices[:services_tax]).to eq(Money.new 25580, 'EUR')
    end

    it 'computes services_with_tax (Services prices with VAT)' do
      expect(prices[:services_with_tax]).to eq(Money.new 153480, 'EUR')
    end

    it 'computes total_price (global price excluding tax)' do
      expect(prices[:total_price]).to eq(Money.new 154900, 'EUR')
    end

    it 'computes total_tax (total taxes)' do
      expect(prices[:total_tax]).to eq(Money.new 25580, 'EUR')
    end

    it 'computes total_with_price (total price with VAT)' do
      expect(prices[:total_with_tax]).to eq(Money.new 180480, 'EUR')
    end
  end
end
