# TODO: Keep track of this issue
# until this issue is resolved by rails team
# https://github.com/rails/rails/pull/33483
# Already merged but not released
module MonkeyPatches
  require "rails/application_controller"
  class Rails::MailersController < Rails::ApplicationController
    content_security_policy(false)
  end
end
