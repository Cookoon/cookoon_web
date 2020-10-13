require 'rails_helper'

RSpec.describe Menu, type: :model do
  it 'returns the good price per person with margin' do
    chef_with_base_price_500 = build(:chef)
    chef_with_min_price_600 = build(:chef, :with_min_price_instead_of_base_price)
    # p chef_with_base_price_500
    # p chef_with_min_price_600

    menu_for_chef_with_base_price_500 = build(:menu, chef: chef_with_base_price_500)
    menu_for_chef_with_min_price_600 = build(:menu, chef: chef_with_min_price_600)
    # p menu_for_chef_with_base_price_500
    # p menu_for_chef_with_min_price_600

    expect(menu_for_chef_with_base_price_500.computed_price_with_chef_with_margin_per_person(1)).to eq(Money.new 66000, 'EUR')
    expect(menu_for_chef_with_base_price_500.computed_price_with_chef_with_margin_per_person(2)).to eq(Money.new 36000, 'EUR')
    expect(menu_for_chef_with_base_price_500.computed_price_with_chef_with_margin_per_person(10)).to eq(Money.new 12000, 'EUR')
    expect(menu_for_chef_with_base_price_500.computed_price_with_chef_with_margin_per_person(50)).to eq(Money.new 7200, 'EUR')

    expect(menu_for_chef_with_min_price_600.computed_price_with_chef_with_margin_per_person(1)).to eq(Money.new 72000, 'EUR')
    expect(menu_for_chef_with_min_price_600.computed_price_with_chef_with_margin_per_person(2)).to eq(Money.new 36000, 'EUR')
    expect(menu_for_chef_with_min_price_600.computed_price_with_chef_with_margin_per_person(10)).to eq(Money.new 7200, 'EUR')
    expect(menu_for_chef_with_min_price_600.computed_price_with_chef_with_margin_per_person(20)).to eq(Money.new 6000, 'EUR')
    expect(menu_for_chef_with_min_price_600.computed_price_with_chef_with_margin_per_person(50)).to eq(Money.new 6000, 'EUR')
  end

  it 'returns the good price per person with margin and taxes' do
    chef_with_base_price_500 = build(:chef)
    chef_with_min_price_600 = build(:chef, :with_min_price_instead_of_base_price)

    menu_for_chef_with_base_price_500 = build(:menu, chef: chef_with_base_price_500)
    menu_for_chef_with_min_price_600 = build(:menu, chef: chef_with_min_price_600)

    expect(menu_for_chef_with_base_price_500.computed_price_with_chef_with_margin_and_taxes_per_person(1)).to eq(Money.new 79200, 'EUR')
    expect(menu_for_chef_with_base_price_500.computed_price_with_chef_with_margin_and_taxes_per_person(2)).to eq(Money.new 43200, 'EUR')
    expect(menu_for_chef_with_base_price_500.computed_price_with_chef_with_margin_and_taxes_per_person(10)).to eq(Money.new 14400, 'EUR')
    expect(menu_for_chef_with_base_price_500.computed_price_with_chef_with_margin_and_taxes_per_person(50)).to eq(Money.new 8640, 'EUR')

    expect(menu_for_chef_with_min_price_600.computed_price_with_chef_with_margin_and_taxes_per_person(1)).to eq(Money.new 86400, 'EUR')
    expect(menu_for_chef_with_min_price_600.computed_price_with_chef_with_margin_and_taxes_per_person(2)).to eq(Money.new 43200, 'EUR')
    expect(menu_for_chef_with_min_price_600.computed_price_with_chef_with_margin_and_taxes_per_person(10)).to eq(Money.new 8640, 'EUR')
    expect(menu_for_chef_with_min_price_600.computed_price_with_chef_with_margin_and_taxes_per_person(20)).to eq(Money.new 7200, 'EUR')
    expect(menu_for_chef_with_min_price_600.computed_price_with_chef_with_margin_and_taxes_per_person(50)).to eq(Money.new 7200, 'EUR')
  end

  # it 'is invalid without a start date' do
  #   reservation = build(:reservation, start_at: nil)
  #   reservation.valid?
  #   expect(reservation.errors[:start_at]).to include('doit être rempli(e)')
  # end

  # describe 'scopes' do
  #   let(:classic) { create(:reservation) }
  #   let(:paid) { create(:reservation, :paid) }
  #   let(:two_days_ago) { create(:reservation, :created_two_days_ago) }
  #   let(:paid_ten_days_ago) { create(:reservation, :paid, :created_ten_days_ago) }

  #   describe '.dropped_before_payment' do
  #     let(:tested_scope) { described_class.dropped_before_payment }

  #     it 'returns only pending reservations created more than few hours ago' do
  #       expect(tested_scope).to include(two_days_ago)
  #       expect(tested_scope).to_not include(paid, classic)
  #     end
  #   end

  #   describe '.short_notice' do
  #     let!(:paid) { create(:reservation, :paid) }

  #     it 'returns only paid reservations starting in less than few hours' do
  #       Timecop.freeze(10.days.from_now) do
  #         expect(described_class.short_notice).to include(paid)
  #       end
  #       Timecop.freeze(8.days.from_now) do
  #         expect(described_class.short_notice).to_not include(paid)
  #       end
  #     end
  #   end

  #   describe '.stripe_will_not_capture' do
  #     let(:tested_scope) { described_class.stripe_will_not_capture }

  #     it 'returns only paid reservation created more than 7 days ago' do
  #       expect(tested_scope).to include(paid_ten_days_ago)
  #       expect(tested_scope).to_not include(paid, classic)
  #     end
  #   end
  # end
end
