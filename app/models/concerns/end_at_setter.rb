module EndAtSetter
  extend ActiveSupport::Concern

  included do
    after_validation :set_end_at, if: :end_at_needs_update?
  end

  private

  def end_at_needs_update?
    return false unless start_at && duration
    will_save_change_to_start_at? || will_save_change_to_duration?
  end

  def set_end_at
    self.end_at = start_at.in(duration.hours - preparation_tidy_time[self.type_name.to_sym].hours)
  end

  def preparation_tidy_time
    {
      breakfast: 1,
      brunch: 1.5,
      lunch: 2,
      diner: 3,
      diner_cocktail: 2.5,
      lunch_cocktail: 2,
      morning: 1,
      afternoon: 1,
      day: 1,
      amex_lunch: 1.5,
      amex_diner: 3
    }
  end
end
