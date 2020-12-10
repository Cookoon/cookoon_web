# rspec spec/concerns/reservation/price_computer_spec.rb
require 'rails_helper'

RSpec.describe Reservation::PriceComputer do
  describe '#computed_price_attributes' do
    let(:cookoon) { create(:cookoon, price_cents: 9000) }
    let(:reservation) { create(:reservation, cookoon: cookoon, people_count: 10, type_name: 'breakfast', category: 'business') }
    # Removed because already created with initial status
    # let!(:service) { create(:service, reservation: reservation, category: 'breakfast') }
    let!(:service) { create(:service, reservation: reservation, category: 'corporate', status: 'validated') }
    let(:prices) { reservation.computed_price_attributes }

    let(:cookoon_a) { create(:cookoon, price_cents: 3000) }
    let(:chef_a) { create(:chef, base_price_cents: 0, min_price_cents: 200000) }
    let(:menu_a) { create(:menu, chef: chef_a, unit_price_cents: 2500) }
    let(:reservation_a) { create(:reservation, cookoon: cookoon_a, people_count: 2, type_name: 'lunch_cocktail', category: 'customer', menu: menu_a) }
    let!(:service_a_a) { create(:service, reservation: reservation_a, category: 'sommelier') }
    let!(:service_a_b) { create(:service, reservation: reservation_a, category: 'parking') }
    let!(:service_a_f) { create(:service, reservation: reservation_a, category: 'flowers') }
    let!(:service_a_g) { create(:service, reservation: reservation_a, category: 'wine') }
    let!(:service_a_h) { create(:service, reservation: reservation_a, category: 'wine') }
    let!(:service_a_o) { create(:service, reservation: reservation_a, category: 'wine') }
    let(:prices_a) { reservation_a.computed_price_attributes }

    # it 'prints the instances' do
    #   puts reservation.class.to_s.upcase
    #   p reservation
    #   puts "-------------"
    #   puts "PRICES"
    #   p prices
    #   puts "-------------"
    #   reservation.services.each do |service|
    #     puts "#{service.class.to_s.upcase}: #{service.category.upcase}"
    #     p service
    #     puts "-------------"
    #   end
    # end

    it 'returns a Hash' do
      expect(prices).to be_a(Hash)
      expect(prices_a).to be_a(Hash)
    end

    it 'computes cookoon_price' do
      # puts reservation.cookoon.price_cents
      # puts reservation.duration
      # puts prices[:cookoon][:cookoon_price]
      expect(prices[:cookoon][:cookoon_price]).to eq(Money.new 27000, 'EUR')
      expect(prices_a[:cookoon][:cookoon_price]).to eq(Money.new 15000, 'EUR')
    end

    it 'computes butler_price' do
      # puts reservation.duration
      # puts prices[:butler][:butler_price]
      expect(prices[:butler][:butler_price]).to eq(Money.new 26250, 'EUR')
      expect(prices_a[:butler][:butler_price]).to eq(Money.new 21875, 'EUR')
    end

    it 'computes cookoon_butler_price for duration' do
      # puts reservation.cookoon_price_cents
      # puts reservation.butler_price_cents
      # puts prices[:cookoon_butler][:cookoon_butler_price]
      expect(prices[:cookoon_butler][:cookoon_butler_price]).to eq(Money.new 53250, 'EUR')
      expect(prices_a[:cookoon_butler][:cookoon_butler_price]).to eq(Money.new 36875, 'EUR')
    end

    it 'computes menu_price' do
      # puts reservation.menu.unit_price_cents unless reservation.menu.nil?
      # puts reservation.people_count
      # puts prices[:menu][:menu_price]
      expect(prices[:menu][:menu_price]).to eq(Money.new 0, 'EUR')
      expect(prices_a[:menu][:menu_price]).to eq(Money.new 230000, 'EUR')
    end

    it 'computes services_price' do
      # puts reservation.services.pluck(:price_cents) unless reservation.services.nil?
      # puts prices[:services][:services_price]
      expect(prices[:services][:services_price]).to eq(Money.new 27500, 'EUR')
      expect(prices_a[:services][:services_price]).to eq(Money.new 46875, 'EUR')
    end

    it 'computes total_price' do
      # puts prices[:cookoon_butler][:cookoon_butler_price]
      # puts prices[:menu][:menu_price]
      # puts prices[:services][:services_price]
      # puts prices[:total][:total_price]
      expect(prices[:total][:total_price]).to eq(Money.new 80750, 'EUR')
      expect(prices_a[:total][:total_price]).to eq(Money.new 313750, 'EUR')

    end

    it 'computes butler_tax' do
      # puts prices[:butler][:butler_price] * 0.2
      expect(prices[:butler][:butler_tax]).to eq(Money.new 5250, 'EUR')
      expect(prices_a[:butler][:butler_tax]).to eq(Money.new 4375, 'EUR')
    end

    it 'computes cookoon_butler_tax' do
      expect(prices[:cookoon_butler][:cookoon_butler_tax]).to eq(Money.new 5250, 'EUR')
      expect(prices_a[:cookoon_butler][:cookoon_butler_tax]).to eq(Money.new 4375, 'EUR')
    end

    it 'computes menu_tax' do
      expect(prices[:menu][:menu_tax]).to eq(Money.new 0, 'EUR')
      expect(prices_a[:menu][:menu_tax]).to eq(Money.new 46000, 'EUR')
    end

    it 'computes services_tax' do
      expect(prices[:services][:services_tax]).to eq(Money.new 5500, 'EUR')
      expect(prices_a[:services][:services_tax]).to eq(Money.new 9375, 'EUR')
    end

    it 'computes total_tax' do
      # puts prices[:cookoon_butler][:cookoon_butler_tax]
      # puts prices[:menu][:menu_tax]
      # puts prices[:services][:services_tax]
      # puts prices[:total][:total_tax]
      expect(prices[:total][:total_tax]).to eq(Money.new 10750, 'EUR')
      expect(prices_a[:total][:total_tax]).to eq(Money.new 59750, 'EUR')
    end

    it 'computes butler_with_tax' do
      # puts prices[:butler][:butler_price]
      # puts prices[:butler][:butler_tax]
      # puts prices[:butler][:butler_price] + prices[:butler][:butler_tax]
      # puts prices[:butler][:butler_with_tax]
      expect(prices[:butler][:butler_with_tax]).to eq(Money.new 31500, 'EUR')
      expect(prices_a[:butler][:butler_with_tax]).to eq(Money.new 26250, 'EUR')
    end

    it 'computes cookoon_butler_with_tax' do
      expect(prices[:cookoon_butler][:cookoon_butler_with_tax]).to eq(Money.new 58500, 'EUR')
      expect(prices_a[:cookoon_butler][:cookoon_butler_with_tax]).to eq(Money.new 41250, 'EUR')
    end

    it 'computes menu_with_tax' do
      expect(prices[:menu][:menu_with_tax]).to eq(Money.new 0, 'EUR')
      expect(prices_a[:menu][:menu_with_tax]).to eq(Money.new 276000, 'EUR')
    end

    it 'computes services_with_tax' do
      # puts prices[:services]
      expect(prices[:services][:services_with_tax]).to eq(Money.new 33000, 'EUR')
      expect(prices_a[:services][:services_with_tax]).to eq(Money.new 56250, 'EUR')
    end

    it 'computes total_with_tax' do
      # puts prices[:total]
      expect(prices[:total][:total_with_tax]).to eq(Money.new 91500, 'EUR')
      expect(prices_a[:total][:total_with_tax]).to eq(Money.new 373500, 'EUR')
    end
  end
end
