class Availability < ApplicationRecord
  enum time_slot: %i[morning noon afternoon evening]

  TIMES = {
    morning: {
      start_time: 7.hours,
      end_time: 12.hours
    },
    noon: {
      start_time: 12.hours,
      end_time: 14.hours
    },
    afternoon: {
      start_time: 14.hours,
      end_time: 19.hours
    },
    evening: {
      start_time: 19.hours,
      end_time: 26.hours
    }
  }.freeze

  belongs_to :cookoon

  before_validation :set_datetimes, if: :datetimes_need_update?

  # TODO: validation on unicity of availability on time_slot?

  private

  def datetimes_need_update?
    will_save_change_to_date? || will_save_change_to_time_slot?
  end

  def set_datetimes
    self.start_at = date + TIMES.dig(time_slot.to_sym, :start_time)
    self.end_at = date + TIMES.dig(time_slot.to_sym, :end_time)
  end
end
