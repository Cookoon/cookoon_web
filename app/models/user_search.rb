class UserSearch < ApplicationRecord
  scope :recents, -> { where('created_at > ?', 3.days.ago) }
  scope :active_recents, -> { recents.active }
  enum status: [:active, :inactive]

  belongs_to :user
end
