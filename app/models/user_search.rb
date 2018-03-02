class UserSearch < ApplicationRecord
  include EndAtSetter

  scope :recents, -> { where('created_at > ?', 3.days.ago) }
  scope :active_recents, -> { recents.active }
  enum status: [:active, :inactive]

  belongs_to :user

  validates :duration, presence: true
  validates :start_at, presence: true
end
