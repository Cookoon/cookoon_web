require 'rails_helper'

RSpec.describe Pro::Reservation::PriceComputer do
  describe '#computed_price_attributes' do
    let(:cookoon) { create(:cookoon, price_cents: 9000) }
    let(:reservation) { create(:pro_reservation, cookoon: cookoon, duration: 8, people_count: 11) }
    let!(:service) { create(:pro_service, reservation: reservation) }
    let(:prices) { reservation.computed_price_attributes }

    it 'returns a Hash' do
      expect(prices).to be_a(Hash)
    end

    it 'computes cookoon_price for duration with fees' do
      expect(prices[:cookoon_price]).to eq(Money.new 72000, 'EUR')
    end

    it 'computes cookoon_fee (fees taken on cookoon including VAT)' do
      expect(prices[:cookoon_fee]).to eq(Money.new 5040, 'EUR')
    end

    it 'computes cookoon_fee_tax (VAT amount on commission)' do
      expect(prices[:cookoon_fee_tax]).to eq(Money.new 840, 'EUR')
    end

    it 'computes services_price_without_tax_and_fee (sum of all options prices)' do
      expect(prices[:services_price_without_tax_and_fee]).to eq(Money.new 98300, 'EUR')
    end

    it 'computes services_fee (fees taken on services excluding VAT)' do
      expect(prices[:services_fee]).to eq(Money.new 6881, 'EUR')
    end

    it 'computes services_tax (VAT on services)' do
      expect(prices[:services_tax]).to eq(Money.new 21036, 'EUR')
    end

    it 'computes services_price_with_fee (Services prices plus fee)' do
      expect(prices[:services_price_with_fee]).to eq(Money.new 105181, 'EUR')
    end

    it 'computes services_price_full (Services prices plus fee plus tax)' do
      expect(prices[:services_price_full]).to eq(Money.new 126217, 'EUR')
    end

    it 'computes price_excluding_tax (global price excluding tax)' do
      expect(prices[:price_excluding_tax]).to eq(Money.new 181381, 'EUR')
    end

    it 'computes price (global price)' do
      expect(prices[:price]).to eq(Money.new 203257, 'EUR')
    end

    it 'computes tax_total (total taxes)' do
      expect(prices[:tax_total]).to eq(Money.new 21876, 'EUR')
    end
  end
end
