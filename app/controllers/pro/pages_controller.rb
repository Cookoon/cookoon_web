module Pro
  class PagesController < ApplicationController
    skip_after_action :verify_policy_scoped
    skip_after_action :verify_authorized

    def home; end
  end
end
