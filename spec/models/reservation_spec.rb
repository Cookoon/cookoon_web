require 'rails_helper'

RSpec.describe Reservation, type: :model do
  # it 'has a valid factory' do
  #   reservation = build(:reservation)
  #   expect(reservation).to be_valid
  # end

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
