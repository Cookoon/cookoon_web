module DatesOverlapScope
  extend ActiveSupport::Concern

  class_methods do
    # def overlapping(range)
    #   return all if range.blank?
    #   where(<<~SQL, range_start: range.first, range_end: range.last)
    #     (start_at BETWEEN :range_start AND :range_end)
    #     OR (end_at BETWEEN :range_start AND :range_end)
    #     OR (start_at < :range_start AND :range_end < end_at)
    #   SQL
    # end
    def overlapping(range)
      return all if range.blank?
      where(<<~SQL, range_start: range.first, range_end: range.last)
        (:range_start BETWEEN start_at AND end_at)
        OR (:range_end BETWEEN start_at AND end_at)
      SQL
    end
  end
end
