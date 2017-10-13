class CreditCardsController < ApplicationController
  # Try a better approach than skiping once done
  skip_after_action :verify_policy_scoped

  def index
  end
end
