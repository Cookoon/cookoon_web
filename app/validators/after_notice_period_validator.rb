class AfterNoticePeriodValidator < ActiveModel::EachValidator
  NOTICE_PERIOD = 10.hours

  def validate_each(record, attribute, value)
    return unless value

    record.errors.add(attribute, :before_notice_period) if value < NOTICE_PERIOD.from_now
  end
end
