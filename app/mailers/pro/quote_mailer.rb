module Pro
  class QuoteMailer < ApplicationMailer
    include DatetimeHelper
    helper :datetime

    def requested(quote)
      @quote = quote
      @tenant = @quote.user
      mail(to: @tenant.full_email, subject: 'Vous avez demandé un Cookoon pour votre évènement !')
    end
  end
end
