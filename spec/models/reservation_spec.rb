require 'rails_helper'

RSpec.describe Reservation, type: :model do
  # let!(:reservation) { create(:reservation, :with_menu) }
  # let!(:reservation_with_menu_charged) { create(:reservation, :with_menu, aasm_state: 'charged') }
  # let!(:reservation_with_services) { create(:reservation, :with_two_services) }

  # it 'prints the instances' do
  #   # p reservation
  #   # p reservation.menu
  #   # p reservation_with_services
  #   p reservation_with_services.services
  #   p reservation_with_services.services.count
  # end

  it 'has a valid factory' do
    reservation = build(:reservation)
    expect(reservation).to be_valid
  end

  it 'is invalid without a start date' do
    reservation = build(:reservation, start_at: nil)
    reservation.valid?
    expect(reservation.errors[:start_at]).to include('doit être rempli(e)')
  end

  describe 'scopes' do
    let!(:classic) { create(:reservation) }
    let!(:paid) { create(:reservation, :paid) }
    let!(:two_days_ago) { create(:reservation, :created_two_days_ago) }
    let!(:paid_ten_days_ago) { create(:reservation, :paid, :created_ten_days_ago) }
    let!(:charged) { create(:reservation, :charged ) }

    let!(:reservation_initial_with_menu) { create(:reservation, :with_menu) }
    let!(:reservation_charged_with_menu_selected) { create(:reservation, :with_menu, aasm_state: 'charged', menu_status: "selected") }
    let!(:reservation_accepted_with_menu_validated) { create(:reservation, :with_menu, aasm_state: 'accepted', menu_status: "validated") }
    let!(:reservation_accepted_with_menu_payment_required) { create(:reservation, :with_menu, aasm_state: 'accepted', menu_status: "payment_required") }

    let!(:reservation_initial_with_services) { create(:reservation, :with_two_services) }
    let!(:reservation_charged_with_services) { create(:reservation, :with_two_services, aasm_state: 'charged') }
    let!(:reservation_accepted_and_cooked_by_user_with_services) { create(:reservation, :with_two_services, aasm_state: 'accepted', menu_status: 'cooking_by_user') }
    let!(:reservation_menu_payment_captured_with_services) { create(:reservation, :with_two_services, aasm_state: 'menu_payment_captured') }
    let!(:reservation_accepted_and_cooked_by_user_with_services_validated) { create(:reservation, :with_two_services, aasm_state: 'accepted', menu_status: 'cooking_by_user', services_status: 'validated') }
    let!(:reservation_menu_payment_captured_with_services_validated) { create(:reservation, :with_two_services, aasm_state: 'menu_payment_captured', services_status: 'validated') }
    let!(:reservation_accepted_and_cooked_by_user_with_services_payment_required) { create(:reservation, :with_two_services, aasm_state: 'accepted', menu_status: 'cooking_by_user', services_status: 'payment_required') }
    let!(:reservation_menu_payment_captured_with_services_payment_required) { create(:reservation, :with_two_services, aasm_state: 'menu_payment_captured', services_status: 'payment_required') }

    describe '.dropped_before_payment' do
      let(:tested_scope) { described_class.dropped_before_payment }

      it 'returns only pending reservations created more than few hours ago' do
        expect(tested_scope).to include(two_days_ago)
        expect(tested_scope).to_not include(paid, classic)
      end
    end

    describe '.short_notice' do
      let!(:paid) { create(:reservation, :charged) }

      it 'returns only paid reservations starting in less than few hours' do
        Timecop.freeze(10.days.from_now) do
          expect(described_class.short_notice).to include(paid)
        end
        Timecop.freeze(8.days.from_now) do
          expect(described_class.short_notice).to_not include(paid)
        end
      end
    end

    describe '.stripe_will_not_capture' do
      let(:tested_scope) { described_class.stripe_will_not_capture }

      it 'returns only paid reservation created more than 7 days ago' do
        expect(tested_scope).to include(paid_ten_days_ago)
        expect(tested_scope).to_not include(paid, classic)
      end
    end

    describe '.with_menu' do
      it 'returns only reservations with menu' do
        expect(described_class.with_menu).to include(reservation_initial_with_menu, reservation_charged_with_menu_selected, reservation_accepted_with_menu_validated)
        expect(described_class.with_menu).to_not include(classic, paid, two_days_ago, paid_ten_days_ago)
        expect((described_class.with_menu).count).to eq(4)
      end
    end

    describe '.needs_menu_validation' do
      it 'returns only reservations which needs menu validation' do
        expect(described_class.needs_menu_validation).to include(reservation_charged_with_menu_selected)
        expect(described_class.needs_menu_validation).to_not include(reservation_initial_with_menu, reservation_accepted_with_menu_validated, classic, paid, two_days_ago, paid_ten_days_ago)
        expect((described_class.needs_menu_validation).count).to eq(1)
      end
    end

    describe '.needs_menu_payment_asking' do
      it 'returns only reservations which needs menu payment asking' do
        expect(described_class.needs_menu_payment_asking).to include(reservation_accepted_with_menu_validated)
        expect(described_class.needs_menu_payment_asking).to_not include(reservation_charged_with_menu_selected, reservation_initial_with_menu, classic, paid, two_days_ago, paid_ten_days_ago)
        expect((described_class.needs_menu_payment_asking).count).to eq(1)
      end
    end

    describe '.needs_menu_payment' do
      it 'returns only reservations which needs menu payment required' do
        expect(described_class.needs_menu_payment).to include(reservation_accepted_with_menu_payment_required)
        expect(described_class.needs_menu_payment).to_not include(reservation_accepted_with_menu_validated, reservation_charged_with_menu_selected, reservation_initial_with_menu, classic, paid, two_days_ago, paid_ten_days_ago)
        expect((described_class.needs_menu_payment).count).to eq(1)
      end
    end

    describe '.with_services' do
      it 'returns only reservations with services' do
        expect(described_class.with_services).to include(reservation_initial_with_services)
        expect((described_class.with_services).count).to eq(17)
      end
    end

    describe '.needs_services_validation' do
      it 'returns only reservations which needs services validation' do
        expect(described_class.needs_services_validation).to include(reservation_charged_with_services)
        expect(described_class.needs_services_validation).to_not include(reservation_initial_with_services)
        expect((described_class.needs_services_validation).count).to eq(7)
      end
    end

    describe '.needs_services_payment_asking' do
      it 'returns only reservations which needs services payment asking' do
        expect(described_class.needs_services_payment_asking).to include(reservation_accepted_and_cooked_by_user_with_services_validated, reservation_menu_payment_captured_with_services_validated)
        expect(described_class.needs_services_payment_asking).to_not include(reservation_accepted_and_cooked_by_user_with_services, reservation_menu_payment_captured_with_services, reservation_charged_with_services, reservation_initial_with_services)
        expect((described_class.needs_services_payment_asking).count).to eq(2)
      end
    end

    describe '.needs_services_payment' do
      it 'returns only reservations which needs services payment required' do
        expect(described_class.needs_services_payment).to include(reservation_accepted_and_cooked_by_user_with_services_payment_required, reservation_menu_payment_captured_with_services_payment_required)
        expect(described_class.needs_services_payment).to_not include(reservation_accepted_and_cooked_by_user_with_services_validated, reservation_menu_payment_captured_with_services_validated, reservation_accepted_and_cooked_by_user_with_services, reservation_menu_payment_captured_with_services, reservation_charged_with_services, reservation_initial_with_services)
        expect((described_class.needs_services_payment).count).to eq(2)
      end
    end

    describe '.needs_host_action' do
      it 'returns only reservations which needs host action' do
        expect(described_class.needs_host_action).to include(reservation_charged_with_menu_selected, reservation_charged_with_services)
        expect((described_class.needs_host_action).count).to eq(3)
      end
    end

    describe '.needs_admin_action_for_menu' do
      it 'returns only reservations which needs admin action for menu' do
        expect(described_class.needs_admin_action_for_menu).to include(reservation_charged_with_menu_selected, reservation_accepted_with_menu_validated)
        expect((described_class.needs_admin_action_for_menu).count).to eq(2)
      end
    end

    describe '.needs_admin_action_for_services' do
      it 'returns only reservations which needs admin action for services' do
        expect(described_class.needs_admin_action_for_services).to include(reservation_charged_with_menu_selected, reservation_accepted_with_menu_validated, reservation_accepted_with_menu_payment_required, reservation_charged_with_services, reservation_accepted_and_cooked_by_user_with_services, reservation_menu_payment_captured_with_services, reservation_accepted_and_cooked_by_user_with_services_validated, reservation_menu_payment_captured_with_services_validated)
        expect((described_class.needs_admin_action_for_services).count).to eq(9)
      end
    end

    describe '.needs_user_action_for_menu' do
      it 'returns only reservations which needs user action for menu' do
        expect(described_class.needs_user_action_for_menu).to include(reservation_accepted_with_menu_payment_required)
        expect((described_class.needs_user_action_for_menu).count).to eq(1)
      end
    end

    describe '.needs_user_action_for_services' do
      it 'returns only reservations which needs user action for services' do
        expect(described_class.needs_user_action_for_services).to include(reservation_accepted_and_cooked_by_user_with_services_payment_required, reservation_menu_payment_captured_with_services_payment_required)
        expect((described_class.needs_user_action_for_services).count).to eq(2)
      end
    end

    describe '.needs_admin_action' do
      it 'returns only reservations which needs admin action for menu and services' do
        expect(described_class.needs_admin_action).to include(reservation_charged_with_menu_selected, reservation_accepted_with_menu_validated, reservation_accepted_with_menu_payment_required, reservation_charged_with_services, reservation_accepted_and_cooked_by_user_with_services, reservation_menu_payment_captured_with_services, reservation_accepted_and_cooked_by_user_with_services_validated, reservation_menu_payment_captured_with_services_validated)
        expect((described_class.needs_admin_action).count).to eq(9)
      end
    end

    describe '.needs_user_action' do
      it 'returns only reservations which needs user action for menu and services' do
        expect(described_class.needs_user_action).to include(reservation_accepted_with_menu_payment_required, reservation_accepted_and_cooked_by_user_with_services_payment_required, reservation_menu_payment_captured_with_services_payment_required)
        expect((described_class.needs_user_action).count).to eq(3)
      end
    end
  end
end
