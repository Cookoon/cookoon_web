class Unavailability < ApplicationRecord
  self.abstract_class = true

  include DatesOverlapScope

  enum time_slot: %i[morning noon evening]

  scope :future, -> { where('date >= ?', Time.zone.today) }
  scope :unavailable, -> { where(available: false) }

  TIME_SLOTS = {
    morning: {
      start_time: 7.hours,
      end_time: 11.hours,
      display_time: "7h-11h",
      display_type: "(petits-déjeuners)"
    },
    noon: {
      start_time: 11.hours,
      end_time: 18.hours,
      display_time: "11h-18h",
      display_type: "(déjeuners, cocktails déjeunatoires, brunchs)"
    },
    # afternoon: {
    #   start_time: 14.hours,
    #   end_time: 19.hours,
    #   display: '14h-19h'
    # },
    evening: {
      start_time: 18.hours,
      end_time: 25.hours,
      display_time: "18h-1h",
      display_type: "(dîners, cocktails dînatoires)"
    }
  }.freeze

  SETTABLE_WEEKS_AHEAD = 5

  validates :date, presence: true
  validates :time_slot, presence: true

  after_validation :set_datetimes, if: :datetimes_need_update?

  private

  def datetimes_need_update?
    will_save_change_to_date? || will_save_change_to_time_slot?
  end

  def set_datetimes
    return unless date && time_slot
    self.start_at = date.in TIME_SLOTS.dig(time_slot.to_sym, :start_time)
    self.end_at = date.in TIME_SLOTS.dig(time_slot.to_sym, :end_time)
  end
end
