class StripeAccountService
  attr_reader :params, :user, :errors, :account, :stripe_account_link_id_verification

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
    # # To implement later
    # create_stripe_url_id_verification
  end

  def error_messages
    build_errors
  end

  def retrieve_stripe_account
    retrieve_account
  end

  def add_identity_documents_for_existing_account
    retrieve_stripe_account
    create_stripe_url_id_verification
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

  def create_stripe_url_id_verification
    return false unless account
    @stripe_account_link_id_verification = Stripe::AccountLink.create(prepare_account_link)
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error('Failed to create link to verify identity')
    Rails.logger.error(e.message)
    @errors << e.message
    false
  end

  def prepare_account_link
    if Rails.env.development? # Rails.env == "development"
      refresh_url = 'http://localhost:3000/admin/users/hosts'
      return_url = 'http://localhost:3000/admin/users/hosts'
    elsif Rails.env.staging?
      refresh_url = 'https://cookoon-staging.herokuapp.com/admin/users/hosts'
      return_url = 'https://cookoon-staging.herokuapp.com/admin/users/hosts'
    elsif Rails.env.production?
      refresh_url = 'https://membre.cookoon.club/admin/users/hosts'
      return_url = 'https://membre.cookoon.club/admin/users/hosts'
    end

    {
      account: user.stripe_account_id,
      refresh_url: refresh_url, # redirection url if problem
      return_url: return_url, # redirection url after completed
      type: 'account_onboarding',
      collect: 'currently_due'
    }
  end
end
