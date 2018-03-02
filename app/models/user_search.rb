class UserSearch < ApplicationRecord
  include EndAtSetter

  scope :active_recents, -> { active.where('created_at > ?', DEFAULTS[:recent_days].ago) }
  enum status: %i[active inactive]

  DEFAULTS = {
    radius: 10,
    start_in_days: 1.day,
    duration: 2,
    people_count: 4,
    recent_days: 3.days
  }.freeze

  belongs_to :user

  validates :duration, presence: true
  validates :start_at, presence: true

  def self.default
    OpenStruct.new DEFAULTS.slice(:radius)
  end

  def self.default_params
    {
      start_at: Time.zone.now.beginning_of_hour.in(DEFAULTS[:start_in_days]),
      duration: DEFAULTS[:duration],
      people_count: DEFAULTS[:people_count]
    }
  end
end
