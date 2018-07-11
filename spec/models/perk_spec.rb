require 'rails_helper'

RSpec.describe Perk, type: :model do
  it { should delegate(:name).to(:perk_specification) }
  it { should delegate(:icon_name).to(:perk_specification) }
end
