module Pro
  class QuoteMailer < ApplicationMailer
    def requested(quote)
      @quote = quote
      @tenant = @quote.user
      mail(to: @tenant.full_email, subject: 'COOKOON · Votre demande de devis')
    end
  end
end
