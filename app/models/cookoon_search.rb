class CookoonSearch < ApplicationRecord
  include EndAtSetter

  scope :active_recents, -> { active.where('created_at > ?', DEFAULTS[:recent_scope].ago) }

  enum status: %i[active inactive]

  DEFAULTS = {
    radius: 30,
    start_in_days: 1.day,
    duration: 2,
    people_count: 4,
    recent_scope: 3.days,
    hour_range: (7..21)
  }.freeze

  belongs_to :user

  validates :start_at, presence: true, in_future: true # TEMP DISABLED after_notice_period: true
  validates :duration, presence: true
  validates :people_count, presence: true

  def self.default
    OpenStruct.new DEFAULTS.slice(:radius)
  end

  def self.default_params
    start_at = Time.zone.now.beginning_of_hour.in(DEFAULTS[:start_in_days])
    {
      start_at: start_at,
      end_at: start_at.in(DEFAULTS[:duration].hours),
      duration: DEFAULTS[:duration],
      people_count: DEFAULTS[:people_count]
    }
  end

  def to_reservation_attributes
    attributes.with_indifferent_access.slice(
      :user_id,
      :start_at,
      :end_at,
      :people_count,
      :duration
    )
  end

  def time_slots
    DEFAULTS[:hour_range].to_a.flat_map do |hour|
      [{ value: "#{hour}:00", display: "#{hour}h00"}, { value: "#{hour}:30", display: "#{hour}h30"}]
    end.tap(&:pop)
  end
end
