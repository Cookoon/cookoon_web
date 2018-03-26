class NotifierJob < ApplicationJob
  discard_on Postmark::InvalidMessageError
end
