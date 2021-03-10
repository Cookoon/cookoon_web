# rspec spec/concerns/menu/price_computer_spec.rb
require 'rails_helper'

RSpec.describe Menu::PriceComputer do
  describe '#price_with_tax_per_person(people_count)' do
    it 'returns the good price per person with margin' do
      chef_a = build(:chef)
      chef_b = build(:chef, :with_min_price_instead_of_base_price)
      menu_a = (build :menu, chef: chef_a)
      menu_b = (build :menu, chef: chef_b)

      expect(menu_a.price_with_tax_per_person(2)).to eq(Money.new 41500, 'EUR')
      expect(menu_a.price_with_tax_per_person(9)).to eq(Money.new 15000, 'EUR')
      expect(menu_a.price_with_tax_per_person(12)).to eq(Money.new 13000, 'EUR')
      expect(menu_b.price_with_tax_per_person(2)).to eq(Money.new 41500, 'EUR')
      expect(menu_b.price_with_tax_per_person(9)).to eq(Money.new 9500, 'EUR')
      expect(menu_b.price_with_tax_per_person(10)).to eq(Money.new 8500, 'EUR')
      expect(menu_b.price_with_tax_per_person(20)).to eq(Money.new 7000, 'EUR')
      expect(menu_b.price_with_tax_per_person(25)).to eq(Money.new 7000, 'EUR')
    end
  end
end
