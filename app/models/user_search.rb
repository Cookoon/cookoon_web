class UserSearch < ApplicationRecord
  scope :recents, -> { where('created_at > ?', 3.days.ago) }

  belongs_to :user
end
