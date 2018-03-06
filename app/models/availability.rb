class Availability < ApplicationRecord
  include DatesOverlapScope

  enum time_slot: %i[morning noon afternoon evening]

  scope :future, -> { where('date >= ?', Time.zone.today) }
  scope :unavailable, -> { where(available: false) }

  TIME_SLOTS = {
    morning: {
      start_time: 7.hours,
      end_time: 12.hours,
      display: '7h-12h'
    },
    noon: {
      start_time: 12.hours,
      end_time: 14.hours,
      display: '12h-14h'
    },
    afternoon: {
      start_time: 14.hours,
      end_time: 19.hours,
      display: '14h-19h'
    },
    evening: {
      start_time: 19.hours,
      end_time: 26.hours,
      display: '19h-02h'
    }
  }.freeze

  belongs_to :cookoon

  validates :date, presence: true
  validates :time_slot, presence: true
  validates :cookoon, uniqueness: { scope: %i[time_slot date] }

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
