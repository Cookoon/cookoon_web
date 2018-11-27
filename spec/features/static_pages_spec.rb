require 'rails_helper'

RSpec.feature "Static Pages", type: :feature do
  let(:user) { create(:user) }

  describe 'Home pages' do
    before(:each) do
      login_as(user, :scope => :user)
    end

    scenario 'user visits b2c homepage' do
      create(:cookoon)
      visit root_path
      expect(page).to have_current_path '/'
      expect(page).to have_css 'i.co-logo'
    end

    scenario 'user visits b2b homepage' do
      visit pro_root_path
      expect(page).to have_current_path '/pro'
      expect(page).to have_content 'Organisez une expérience originale'
    end
  end
end
