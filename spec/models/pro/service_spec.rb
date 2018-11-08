require 'rails_helper'

RSpec.describe Pro::Service, type: :model do
  it 'has a valid factory' do
    service = build(:pro_service)
    expect(service).to be_valid
  end
end
