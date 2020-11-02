require 'rails_helper'

RSpec.describe StripeAccountService do
  let(:user) { create(:user, :with_job, :with_personal_taste, :with_motivation) }
  let(:params) { ActionController::Parameters.new('first_name' => user.first_name, 'last_name' => user.last_name, 'dob(3i)' => '1', 'dob(2i)' => '1', 'dob(1i)' => '1965', 'address' => { 'line1' => '1 rue eugène eichenberger', 'postal_code' => '92800', 'city' => 'PUTEAUX' }, 'account_token' => 'ct_1ClzG4JwSREaPZl4WsUkeOtl', 'bank_account_token' => 'btok_1ClzG4JwSREaPZl4jINzAaeE') }
  let(:invalid_params) { params.slice(:first_name, :last_name) }

  describe '#create_and_link_account' do
    context 'with invalid params' do
      let(:service) { described_class.new(params: invalid_params, user: user) }

      it 'returns false' do
        expect(service.create_and_link_account).to eq false
      end

      it 'does not update user' do
        user_last_update = user.updated_at
        service.create_and_link_account
        expect(user.updated_at).to eq(user_last_update)
      end
    end

    context 'with valid params' do
      let(:service) { described_class.new(params: params, user: user) }
      before(:each) do
        VCR.use_cassette 'stripe_account/create_account_success' do
          service.create_and_link_account
        end
      end

      it 'creates an account' do
        expect(service.account).to_not be_nil
      end

      it 'creates a bank account on that account' do
        VCR.use_cassette 'stripe_account/retrieve_account' do
          service.retrieve_stripe_account
        end
        expect(service.account.external_accounts.total_count).to eq 1
      end

      it 'updates user' do
        expect(user.stripe_account_id).to_not be_nil
      end
    end
  end

  describe '#error_messages' do
    context 'some params are missing' do
      let(:service) { described_class.new(params: invalid_params, user: user) }

      it 'returns a message including every param missing' do
        service.send(:check_params)
        expect(service.error_messages).to include('adresse', 'date de naissance', 'IBAN')
      end
    end

    context 'params are ok ' do
      let(:service) { described_class.new(params: params, user: user) }

      context 'something went wrong with stripe' do
        it 'returns Stripe Error message' do
          VCR.use_cassette 'stripe_account/create_account_token_already_used' do
            service.create_and_link_account
            expect(service.error_messages).to include('has already been used')
          end
        end
      end

      context 'something else went wrong' do
        it 'returns a generic error message' do
          expect(service.error_messages).to include('veuillez retenter ultérieurement')
        end
      end
    end
  end

  describe '#retrieve_stripe_account' do
    context 'user has an account' do
      it 'returns Stripe Account object' do
        VCR.use_cassette 'stripe_account/retrieve_account_success' do
          user = create(:user, :with_stripe_account, :with_job, :with_personal_taste, :with_motivation)
          service = described_class.new(params: params, user: user)
          account = service.retrieve_stripe_account
          expect(account).to be_a(Stripe::Account)
        end
      end
    end

    context 'user does not have any account' do
      it 'returns false' do
        service = described_class.new(params: params, user: user)
        expect(service.retrieve_stripe_account).to eq false
      end
    end
  end
end
