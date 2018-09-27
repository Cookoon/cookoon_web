module Pro
  class ApplicationMailer < ActionMailer::Base
    include Roadie::Rails::Automatic
    layout 'pro/mailer'
    helper :branch_url
  end
end
