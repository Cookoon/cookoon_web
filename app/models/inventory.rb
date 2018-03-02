class Inventory < ApplicationRecord
  include TimeRangeBuilder

  scope :checked_out_in_day_range_around, ->(date_time) { checked_out.where checkout_at: day_range(date_time) }

  belongs_to :reservation
  has_attachments :checkin_photos
  has_attachments :checkout_photos

  enum status: %i[checked_in checked_out]
end
