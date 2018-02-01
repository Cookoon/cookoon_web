class UserSearch < ApplicationRecord
  scope :recents, -> { where('created_at > ?', 3.days.ago) }
  enum status: [:active, :inactive]

  belongs_to :user
end
