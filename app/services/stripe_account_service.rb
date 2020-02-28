class StripeAccountService
  attr_reader :params, :user, :errors, :account

  def initialize(attributes)
    @params = attributes[:params]
    @user = attributes[:user]
    @errors = []
  end

  def create_and_link_account
    return false unless params_valid?
    retrieve_or_create_account
    account_updated = link_bank_account
    user.update(stripe_account_id: account.id) if account_updated
  end

  def error_messages
    build_errors
  end

  def retrieve_stripe_account
    retrieve_account
  end

  private

  def retrieve_or_create_account
    user&.stripe_account_id.nil? ? create_account : retrieve_account
  end

  def create_account
    return false unless user
    @account = Stripe::Account.create(prepare_account)
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error('Failed to create Stripe account')
    Rails.logger.error(e.message)
    @errors << e.message
    false
  end

  def retrieve_account
    return false unless user&.stripe_account_id
    @account = Stripe::Account.retrieve(user.stripe_account_id)
  rescue Stripe::PermissionError => e
    Rails.logger.error('Failed to retrieve Stripe account')
    Rails.logger.error(e.message)
    @errors << e.message
    false
  end

  def link_bank_account
    return false unless account
    account.external_accounts.create(external_account: params['bank_account_token'])
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error('Failed to enrich Stripe account')
    Rails.logger.error(e.message)
    @errors << e.message
    false
  end

  def params_valid?
    check_params
    @errors.none?
  end

  def check_params
    name_params = [params['first_name'], params['last_name']]
    address_params = [params.dig('address', 'line1'), params.dig('address', 'postal_code'), params.dig('address', 'city')]
    dob_params = [params['dob(3i)'], params['dob(2i)'], params['dob(1i)']]
    @errors << 'Votre nom complet est obligatoire' if name_params.any?(&:blank?)
    @errors << 'Votre adresse est obligatoire' if address_params.any?(&:blank?)
    @errors << 'Votre date de naissance est obligatoire' if dob_params.any?(&:blank?)
    @errors << 'Votre IBAN est obligatoire' if params['bank_account_token'].blank?
  end

  def prepare_account
    {
      type: 'custom',
      country: 'FR',
      email: user.email,
      account_token: params[:account_token],
      # add requested_capabilities because required
      # transfers : new api / legacy_payments : old one but old accounts were created with that
      requested_capabilities: ['transfers', 'legacy_payments']
    }
  end

  def build_errors
    if errors.any?
      errors.join(', ')
    else
      <<~ERROR
        Une erreur est survenue avec notre partenaire de paiement veuillez retenter ultérieurement,
        pour des raisons de sécurité nous ne conservons pas vos données bancaires veuillez les saisir à nouveau.
      ERROR
    end
  end

end
