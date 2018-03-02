module EndAtSetter
  extend ActiveSupport::Concern

  included do
    after_validation :set_end_at, if: :end_at_needs_update?
  end

  private
  
  def end_at_needs_update?
    will_save_change_to_start_at? || will_save_change_to_duration?
  end

  def set_end_at
    self.end_at = start_at.in(duration.hours)
  end
end
