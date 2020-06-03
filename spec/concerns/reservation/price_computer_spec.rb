require 'rails_helper'

RSpec.describe Reservation::PriceComputer do
  describe '#computed_price_attributes' do
    let(:cookoon) { create(:cookoon, price_cents: 9000) }
    let(:reservation) { create(:reservation, cookoon: cookoon, people_count: 10, type_name: 'breakfast', category: 'business') }
    let!(:service) { create(:service, reservation: reservation, category: 'breakfast') }
    let!(:service) { create(:service, reservation: reservation, category: 'corporate') }
    let(:prices) { reservation.computed_price_attributes }

    it 'prints the instances' do
      puts reservation.class.to_s.upcase
      p reservation
      puts "-------------"
      puts "PRICES"
      p prices
      puts "-------------"
      reservation.services.each do |service|
        puts "#{service.class.to_s.upcase}: #{service.category.upcase}"
        p service
        puts "-------------"
      end
    end

    it 'returns a Hash' do
      expect(prices).to be_a(Hash)
    end

    it 'computes cookoon_price' do
      puts reservation.cookoon.price_cents
      puts reservation.duration
      puts prices[:cookoon][:cookoon_price]
      expect(prices[:cookoon][:cookoon_price]).to eq(Money.new 27000, 'EUR')
    end

    it 'computes butler_price' do
      # puts reservation.duration
      # puts prices[:butler][:butler_price]
      expect(prices[:butler][:butler_price]).to eq(Money.new 31500, 'EUR')
    end

    it 'computes cookoon_butler_price for duration' do
      # puts reservation.cookoon_price_cents
      # puts reservation.butler_price_cents
      # puts prices[:cookoon_butler][:cookoon_butler_price]
      expect(prices[:cookoon_butler][:cookoon_butler_price]).to eq(Money.new 58500, 'EUR')
    end

    it 'computes menu_price' do
      # puts reservation.menu.unit_price_cents unless reservation.menu.nil?
      # puts reservation.people_count
      # puts prices[:menu][:menu_price]
      expect(prices[:menu][:menu_price]).to eq(Money.new 0, 'EUR')
    end

    it 'computes services_price' do
      # puts reservation.services.pluck(:price_cents) unless reservation.services.nil?
      # puts prices[:services][:services_price]
      expect(prices[:services][:services_price]).to eq(Money.new 50000, 'EUR')
    end

    it 'computes total_price' do
      # puts prices[:cookoon_butler][:cookoon_butler_price]
      # puts prices[:menu][:menu_price]
      # puts prices[:services][:services_price]
      # puts prices[:total][:total_price]
      expect(prices[:total][:total_price]).to eq(Money.new 108500, 'EUR')
    end

    it 'computes butler_tax' do
      # puts prices[:butler][:butler_price] * 0.2
      expect(prices[:butler][:butler_tax]).to eq(Money.new 6300, 'EUR')
    end

    it 'computes cookoon_butler_tax' do
      expect(prices[:cookoon_butler][:cookoon_butler_tax]).to eq(Money.new 6300, 'EUR')
    end

    it 'computes menu_tax' do
      expect(prices[:menu][:menu_tax]).to eq(Money.new 0, 'EUR')
    end

    it 'computes services_tax' do
      expect(prices[:services][:services_tax]).to eq(Money.new 10000, 'EUR')
    end

    it 'computes total_tax' do
      # puts prices[:cookoon_butler][:cookoon_butler_tax]
      # puts prices[:menu][:menu_tax]
      # puts prices[:services][:services_tax]
      # puts prices[:total][:total_tax]
      expect(prices[:total][:total_tax]).to eq(Money.new 16300, 'EUR')
    end

    it 'computes butler_with_tax' do
      # puts prices[:butler][:butler_price]
      # puts prices[:butler][:butler_tax]
      # puts prices[:butler][:butler_price] + prices[:butler][:butler_tax]
      # puts prices[:butler][:butler_with_tax]
      expect(prices[:butler][:butler_with_tax]).to eq(Money.new 37800, 'EUR')
    end

    it 'computes cookoon_butler_with_tax' do
      expect(prices[:cookoon_butler][:cookoon_butler_with_tax]).to eq(Money.new 64800, 'EUR')
    end

    it 'computes menu_with_tax' do
      expect(prices[:menu][:menu_with_tax]).to eq(Money.new 0, 'EUR')
    end

    it 'computes services_with_tax' do
      expect(prices[:services][:services_with_tax]).to eq(Money.new 60000, 'EUR')
    end

    it 'computes total_with_tax' do
      # puts prices[:cookoon_butler][:cookoon_butler_with_tax]
      # puts prices[:menu][:menu_with_tax]
      # puts prices[:services][:services_with_tax]
      # puts prices[:total][:total_with_tax]
      expect(prices[:total][:total_with_tax]).to eq(Money.new 124800, 'EUR')
    end
  end
end
