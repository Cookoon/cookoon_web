require 'rails_helper'

RSpec.describe Availability, type: :model do
  it 'is valid with a cookoon, date and time_slot' do
    availability = build(:availability)
    expect(availability).to be_valid
  end

  it 'is invalid without a cookoon' do
    availability = build(:availability, cookoon: nil)
    availability.valid?
    expect(availability.errors[:cookoon]).to include('doit exister')
  end

  it 'does not allow duplicate availabilities per cookoon for a day and time_slot combination' do
    cookoon = create(:cookoon)
    create(:availability, cookoon: cookoon)

    availability = build(:availability, cookoon: cookoon)
    availability.valid?
    expect(availability.errors[:cookoon]).to include('Une disponibilité existe déja sur ce créneau pour ce Cookoon')
  end

  describe '#set_datetimes' do
    it 'sets start_at and end_at after validation' do
      availability = build(:availability)
      availability.valid?
      expect(availability.start_at).to be_present
      expect(availability.end_at).to be_present
    end

    it 'updates start_at and end_at after date update' do
      availability = create(:availability)
      availability.date = Date.tomorrow
      availability.valid?
      expect(availability.start_at.to_date).to eq Date.tomorrow
      expect(availability.end_at.to_date).to eq Date.tomorrow
    end

    it 'updates start_at and end_at after time_slot update' do
      availability = create(:availability)
      availability.time_slot = :noon
      availability.valid?
      expect(availability.start_at.hour).to eq 11
      expect(availability.end_at.hour).to eq 18
    end
  end
end
