# rspec spec/concerns/reservation/price_computer_spec.rb
require 'rails_helper'

require 'support/reservation_helpers'

RSpec.configure do |c|
  c.include ReservationHelpers
end

RSpec.describe Reservation::PriceComputer do
  describe '#computed_price_attributes' do
    let(:cookoon) { create(:cookoon, price_cents: 9000) }
    let(:reservation) { create(:reservation, cookoon: cookoon, people_count: 10, type_name: 'breakfast', category: 'business') }
    # Removed because already created with initial status
    # let!(:service) { create(:service, reservation: reservation, category: 'breakfast') }
    let!(:service) { create(:service, reservation: reservation, category: 'corporate', status: 'validated') }
    let(:prices) { reservation.computed_price_attributes }

    # let(:cookoon_a) { create(:cookoon, price_cents: 3000) }
    let(:cookoon_a) { create(:cookoon, price_cents: 3000, amex: true, amex_price_cents: 50000) }
    # let(:chef_a) { create(:chef, base_price_cents: 0, min_price_cents: 200000) }
    let(:chef_a) { create(:chef, base_price_cents: 0, min_price_cents: 200000, amex: true) }
    let(:chef_b) { create(:chef, base_price_cents: 0, min_price_cents: 40000, amex: true) }
    let(:menu_a) { create(:menu, chef: chef_a, unit_price_cents: 2500) }
    let(:menu_amex) { create(:menu, chef: chef_a, status: 'amex', unit_price_cents: 0) }
    let(:menu_amex_b) { create(:menu, chef: chef_b, status: 'amex', unit_price_cents: 0) }
    let(:reservation_a) { create(:reservation, cookoon: cookoon_a, people_count: 2, type_name: 'lunch_cocktail', category: 'customer', menu: menu_a) }
    let(:reservation_amex) { create(:reservation, cookoon: cookoon_a, people_count: 2, type_name: 'amex_diner', category: 'amex', menu: menu_amex) }
    let(:reservation_amex_b) { create(:reservation, cookoon: cookoon_a, people_count: 2, type_name: 'amex_diner', category: 'amex', menu: menu_amex_b) }
    let!(:service_a_a) { create(:service, reservation: reservation_a, category: 'sommelier') }
    let!(:service_a_b) { create(:service, reservation: reservation_a, category: 'parking') }
    let!(:service_a_f) { create(:service, reservation: reservation_a, category: 'flowers') }
    let!(:service_a_g) { create(:service, reservation: reservation_a, category: 'wine') }
    let!(:service_a_h) { create(:service, reservation: reservation_a, category: 'wine') }
    let!(:service_a_o) { create(:service, reservation: reservation_a, category: 'wine') }
    let(:prices_a) { reservation_a.computed_price_attributes }
    let(:prices_amex) { reservation_amex.computed_price_attributes }
    let(:prices_amex_b) { reservation_amex_b.computed_price_attributes }

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
      expect(prices_amex).to be_a(Hash)
      expect(prices_amex_b).to be_a(Hash)
    end

    it 'computes cookoon_price' do
      # puts reservation.cookoon.price_cents
      # puts reservation.duration
      # puts prices[:cookoon][:cookoon_price]
      expect(prices[:cookoon][:cookoon_price]).to eq(Money.new 27000, 'EUR')
      expect(prices_a[:cookoon][:cookoon_price]).to eq(Money.new 15000, 'EUR')
      expect(prices_amex[:cookoon][:cookoon_price]).to eq(Money.new 50000, 'EUR')
      expect(prices_amex_b[:cookoon][:cookoon_price]).to eq(Money.new 50000, 'EUR')
    end

    it 'computes butler_price' do
      # puts reservation.duration
      # puts prices[:butler][:butler_price]
      expect(prices[:butler][:butler_price]).to eq(Money.new 26250, 'EUR')
      expect(prices_a[:butler][:butler_price]).to eq(Money.new 21875, 'EUR')
      expect(prices_amex[:butler][:butler_price]).to eq(Money.new 0, 'EUR')
      expect(prices_amex_b[:butler][:butler_price]).to eq(Money.new 0, 'EUR')
    end

    it 'computes cookoon_butler_price for duration' do
      # puts reservation.cookoon_price_cents
      # puts reservation.butler_price_cents
      # puts prices[:cookoon_butler][:cookoon_butler_price]
      expect(prices[:cookoon_butler][:cookoon_butler_price]).to eq(Money.new 53250, 'EUR')
      expect(prices_a[:cookoon_butler][:cookoon_butler_price]).to eq(Money.new 36875, 'EUR')
      expect(prices_amex[:cookoon_butler][:cookoon_butler_price]).to eq(Money.new 50000, 'EUR')
      expect(prices_amex_b[:cookoon_butler][:cookoon_butler_price]).to eq(Money.new 50000, 'EUR')
    end

    it 'computes menu_price' do
      # puts reservation.menu.unit_price_cents unless reservation.menu.nil?
      # puts reservation.people_count
      # puts prices[:menu][:menu_price]
      expect(prices[:menu][:menu_price]).to eq(Money.new 0, 'EUR')
      expect(prices_a[:menu][:menu_price]).to eq(Money.new 230000, 'EUR')
      expect(prices_amex[:menu][:menu_price]).to eq(Money.new 230000, 'EUR')
      expect(prices_amex_b[:menu][:menu_price]).to eq(Money.new 46000, 'EUR')
    end

    it 'computes services_price' do
      # puts reservation.services.pluck(:price_cents) unless reservation.services.nil?
      # puts prices[:services][:services_price]
      expect(prices[:services][:services_price]).to eq(Money.new 27500, 'EUR')
      expect(prices_a[:services][:services_price]).to eq(Money.new 46875, 'EUR')
      expect(prices_amex[:services][:services_price]).to eq(Money.new 0, 'EUR')
      expect(prices_amex_b[:services][:services_price]).to eq(Money.new 0, 'EUR')
    end

    it 'computes total_price' do
      # puts prices[:cookoon_butler][:cookoon_butler_price]
      # puts prices[:menu][:menu_price]
      # puts prices[:services][:services_price]
      # puts prices[:total][:total_price]
      expect(prices[:total][:total_price]).to eq(Money.new 80750, 'EUR')
      expect(prices_a[:total][:total_price]).to eq(Money.new 313750, 'EUR')
      expect(prices_amex[:total][:total_price]).to eq(Money.new 106000, 'EUR')
      expect(prices_amex_b[:total][:total_price]).to eq(Money.new 106000, 'EUR')
    end

    it 'computes butler_tax' do
      # puts prices[:butler][:butler_price] * 0.2
      expect(prices[:butler][:butler_tax]).to eq(Money.new 5250, 'EUR')
      expect(prices_a[:butler][:butler_tax]).to eq(Money.new 4375, 'EUR')
      expect(prices_amex[:butler][:butler_tax]).to eq(Money.new 0, 'EUR')
      expect(prices_amex_b[:butler][:butler_tax]).to eq(Money.new 0, 'EUR')
    end

    it 'computes cookoon_butler_tax' do
      expect(prices[:cookoon_butler][:cookoon_butler_tax]).to eq(Money.new 5250, 'EUR')
      expect(prices_a[:cookoon_butler][:cookoon_butler_tax]).to eq(Money.new 4375, 'EUR')
      expect(prices_amex[:cookoon_butler][:cookoon_butler_tax]).to eq(Money.new 0, 'EUR')
      expect(prices_amex_b[:cookoon_butler][:cookoon_butler_tax]).to eq(Money.new 0, 'EUR')
    end

    it 'computes menu_tax' do
      expect(prices[:menu][:menu_tax]).to eq(Money.new 0, 'EUR')
      expect(prices_a[:menu][:menu_tax]).to eq(Money.new 46000, 'EUR')
      expect(prices_amex[:menu][:menu_tax]).to eq(Money.new 46000, 'EUR')
      expect(prices_amex_b[:menu][:menu_tax]).to eq(Money.new 9200, 'EUR')
    end

    it 'computes services_tax' do
      expect(prices[:services][:services_tax]).to eq(Money.new 5500, 'EUR')
      expect(prices_a[:services][:services_tax]).to eq(Money.new 9375, 'EUR')
      expect(prices_amex[:services][:services_tax]).to eq(Money.new 0, 'EUR')
      expect(prices_amex_b[:services][:services_tax]).to eq(Money.new 0, 'EUR')
    end

    it 'computes total_tax' do
      # puts prices[:cookoon_butler][:cookoon_butler_tax]
      # puts prices[:menu][:menu_tax]
      # puts prices[:services][:services_tax]
      # puts prices[:total][:total_tax]
      expect(prices[:total][:total_tax]).to eq(Money.new 10750, 'EUR')
      expect(prices_a[:total][:total_tax]).to eq(Money.new 59750, 'EUR')
      expect(prices_amex[:total][:total_tax]).to eq(Money.new 14000, 'EUR')
      expect(prices_amex_b[:total][:total_tax]).to eq(Money.new 14000, 'EUR')
    end

    it 'computes butler_with_tax' do
      # puts prices[:butler][:butler_price]
      # puts prices[:butler][:butler_tax]
      # puts prices[:butler][:butler_price] + prices[:butler][:butler_tax]
      # puts prices[:butler][:butler_with_tax]
      expect(prices[:butler][:butler_with_tax]).to eq(Money.new 31500, 'EUR')
      expect(prices_a[:butler][:butler_with_tax]).to eq(Money.new 26250, 'EUR')
      expect(prices_amex[:butler][:butler_with_tax]).to eq(Money.new 0, 'EUR')
      expect(prices_amex_b[:butler][:butler_with_tax]).to eq(Money.new 0, 'EUR')
    end

    it 'computes cookoon_butler_with_tax' do
      expect(prices[:cookoon_butler][:cookoon_butler_with_tax]).to eq(Money.new 58500, 'EUR')
      expect(prices_a[:cookoon_butler][:cookoon_butler_with_tax]).to eq(Money.new 41250, 'EUR')
      expect(prices_amex[:cookoon_butler][:cookoon_butler_with_tax]).to eq(Money.new 50000, 'EUR')
      expect(prices_amex_b[:cookoon_butler][:cookoon_butler_with_tax]).to eq(Money.new 50000, 'EUR')
    end

    it 'computes menu_with_tax' do
      expect(prices[:menu][:menu_with_tax]).to eq(Money.new 0, 'EUR')
      expect(prices_a[:menu][:menu_with_tax]).to eq(Money.new 276000, 'EUR')
      expect(prices_amex[:menu][:menu_with_tax]).to eq(Money.new 276000, 'EUR')
      expect(prices_amex_b[:menu][:menu_with_tax]).to eq(Money.new 55200, 'EUR')
    end

    it 'computes services_with_tax' do
      # puts prices[:services]
      expect(prices[:services][:services_with_tax]).to eq(Money.new 33000, 'EUR')
      expect(prices_a[:services][:services_with_tax]).to eq(Money.new 56250, 'EUR')
      expect(prices_amex[:services][:services_with_tax]).to eq(Money.new 0, 'EUR')
      expect(prices_amex_b[:services][:services_with_tax]).to eq(Money.new 0, 'EUR')
    end

    it 'computes total_with_tax' do
      # puts prices[:total]
      expect(prices[:total][:total_with_tax]).to eq(Money.new 91500, 'EUR')
      expect(prices_a[:total][:total_with_tax]).to eq(Money.new 373500, 'EUR')
      expect(prices_amex[:total][:total_with_tax]).to eq(Money.new 120000, 'EUR')
      expect(prices_amex_b[:total][:total_with_tax]).to eq(Money.new 120000, 'EUR')
    end
  end

  describe '#computed_price_attributes for menu and total' do
    let(:chef_with_base_price) { create(:chef, base_price_cents: 61200) }
    let(:chef_with_min_price) { create(:chef, :with_min_price_instead_of_base_price, min_price_cents: 51200) }

    let(:menu_for_chef_with_base_price) { create(:menu, chef: chef_with_base_price, unit_price_cents: 11800) }
    let(:menu_for_chef_with_min_price) { create(:menu, chef: chef_with_min_price, unit_price_cents: 5200) }

    ### CHEF WITH MIN PRICE
    it 'computes prices for reservation with 2 people and chef with min price' do
      create_reservation(2, menu_for_chef_with_min_price) # method in spec/support/reservation_helpers
      # => create cookoon, @reservation
      @computed_prices = @reservation.computed_price_attributes
      @results = {
        menu: { menu_price: Money.new(59167, 'EUR'), menu_tax: Money.new(11833, 'EUR'), menu_with_tax: Money.new(71000, 'EUR') },
        total: { total_price: Money.new(124792, 'EUR'), total_tax: Money.new(17958, 'EUR'), total_with_tax: Money.new(142750, 'EUR') }
      }
      test_menu_and_total_prices # method in spec/support/reservation_helpers
      expect(@reservation.menu.price_with_tax_per_person(@reservation.people_count)).to eq(Money.new(35500, 'EUR'))
    end

    it 'computes prices for reservation with 9 people and chef with min price' do
      create_reservation(9, menu_for_chef_with_min_price)
      @computed_prices = @reservation.computed_price_attributes
      @results = {
        menu: { menu_price: Money.new(60000, 'EUR'), menu_tax: Money.new(12000, 'EUR'), menu_with_tax: Money.new(72000, 'EUR') },
        total: { total_price: Money.new(125625, 'EUR'), total_tax: Money.new(18125, 'EUR'), total_with_tax: Money.new(143750, 'EUR') }
      }
      test_menu_and_total_prices
      expect(@reservation.menu.price_with_tax_per_person(@reservation.people_count)).to eq(Money.new(8000, 'EUR'))
    end

    it 'computes prices for reservation with 10 people and chef with min price' do
      create_reservation(10, menu_for_chef_with_min_price)
      @computed_prices = @reservation.computed_price_attributes
      @results = {
        menu: { menu_price: Money.new(62500, 'EUR'), menu_tax: Money.new(12500, 'EUR'), menu_with_tax: Money.new(75000, 'EUR') },
        total: { total_price: Money.new(128125, 'EUR'), total_tax: Money.new(18625, 'EUR'), total_with_tax: Money.new(146750, 'EUR') }
      }
      test_menu_and_total_prices
      expect(@reservation.menu.price_with_tax_per_person(@reservation.people_count)).to eq(Money.new(7500, 'EUR'))
    end

    it 'computes prices for reservation with 22 people and chef with min price' do
      create_reservation(22, menu_for_chef_with_min_price)
      @computed_prices = @reservation.computed_price_attributes
      @results = {
        menu: { menu_price: Money.new(137500, 'EUR'), menu_tax: Money.new(27500, 'EUR'), menu_with_tax: Money.new(165000, 'EUR') },
        total: { total_price: Money.new(264375, 'EUR'), total_tax: Money.new(45875, 'EUR'), total_with_tax: Money.new(310250, 'EUR') }
      }
      test_menu_and_total_prices
      expect(@reservation.menu.price_with_tax_per_person(@reservation.people_count)).to eq(Money.new(7500, 'EUR'))
    end

    ### CHEF WITH BASE PRICE
    it 'computes prices for reservation with 2 people and chef with base price' do
      create_reservation(2, menu_for_chef_with_base_price)
      @computed_prices = @reservation.computed_price_attributes
      @results = {
        menu: { menu_price: Money.new(98333, 'EUR'), menu_tax: Money.new(19667, 'EUR'), menu_with_tax: Money.new(118000, 'EUR') },
        total: { total_price: Money.new(163958, 'EUR'), total_tax: Money.new(25792, 'EUR'), total_with_tax: Money.new(189750, 'EUR') }
      }
      test_menu_and_total_prices # method in spec/support/reservation_helpers
      expect(@reservation.menu.price_with_tax_per_person(@reservation.people_count)).to eq(Money.new(59000, 'EUR'))
    end

    it 'computes prices for reservation with 9 people and chef with base price' do
      create_reservation(9, menu_for_chef_with_base_price)
      @computed_prices = @reservation.computed_price_attributes
      @results = {
        menu: { menu_price: Money.new(195000, 'EUR'), menu_tax: Money.new(39000, 'EUR'), menu_with_tax: Money.new(234000, 'EUR') },
        total: { total_price: Money.new(260625, 'EUR'), total_tax: Money.new(45125, 'EUR'), total_with_tax: Money.new(305750, 'EUR') }
      }
      test_menu_and_total_prices
      expect(@reservation.menu.price_with_tax_per_person(@reservation.people_count)).to eq(Money.new(26000, 'EUR'))
    end

    it 'computes prices for reservation with 10 people and chef with base price' do
      create_reservation(10, menu_for_chef_with_base_price)
      @computed_prices = @reservation.computed_price_attributes
      @results = {
        menu: { menu_price: Money.new(208333, 'EUR'), menu_tax: Money.new(41667, 'EUR'), menu_with_tax: Money.new(250000, 'EUR') },
        total: { total_price: Money.new(273958, 'EUR'), total_tax: Money.new(47792, 'EUR'), total_with_tax: Money.new(321750, 'EUR') }
      }
      test_menu_and_total_prices
      expect(@reservation.menu.price_with_tax_per_person(@reservation.people_count)).to eq(Money.new(25000, 'EUR'))
    end

    it 'computes prices for reservation with 22 people and chef with base price' do
      create_reservation(22, menu_for_chef_with_base_price)
      @computed_prices = @reservation.computed_price_attributes
      @results = {
        menu: { menu_price: Money.new(375833, 'EUR'), menu_tax: Money.new(75167, 'EUR'), menu_with_tax: Money.new(451000, 'EUR') },
        total: { total_price: Money.new(502708, 'EUR'), total_tax: Money.new(93542, 'EUR'), total_with_tax: Money.new(596250, 'EUR') }
      }
      test_menu_and_total_prices
      expect(@reservation.menu.price_with_tax_per_person(@reservation.people_count)).to eq(Money.new(20500, 'EUR'))
    end
  end
end
