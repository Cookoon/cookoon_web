module Pro
  class QuotePreview < ActionMailer::Preview
    def requested
      QuoteMailer.requested(Quote.last)
    end
  end
end
