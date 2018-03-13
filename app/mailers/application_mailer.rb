class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  layout 'mailer'
  helper :branch_url
end
