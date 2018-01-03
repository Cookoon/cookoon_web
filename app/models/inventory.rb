class Inventory < ApplicationRecord
  belongs_to :reservation
  has_attachments :checkin_photos
  has_attachments :checkout_photos

  enum status: %i[checked_in checked_out]
end
