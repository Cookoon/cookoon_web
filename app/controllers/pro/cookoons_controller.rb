module Pro
  class CookoonsController < ApplicationController
    skip_after_action :verify_policy_scoped
    skip_after_action :verify_authorized
    
    def index; end
  end
end
