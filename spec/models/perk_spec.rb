require 'rails_helper'

RSpec.describe Perk, type: :model do
  it 'is valid' do
    perk = build(:perk)
    expect(perk).to be_valid
  end
  it { should delegate(:name).to(:perk_specification) }
  it { should delegate(:icon_name).to(:perk_specification) }
end
