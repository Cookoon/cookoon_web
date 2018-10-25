class InFutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value

    record.errors.add(attribute, :cannot_be_passed) if value < Time.zone.now
  end
end
