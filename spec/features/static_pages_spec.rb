require 'rails_helper'

RSpec.feature "Static Pages", type: :feature do
  let(:user) { create(:user) }

  describe 'Home pages' do
    context 'user is logged in' do
      before(:each) do
        login_as(user, :scope => :user)
      end

      scenario 'user visits root path' do
        create(:cookoon, :approved)
        visit root_path
        expect(page).to have_current_path '/'
        expect(page).to have_css 'i.co-logo'
        expect(page).to have_content 'Les derniers Cookoons'
      end

      scenario 'user visits pro root path' do
        visit pro_root_path
        expect(page).to have_current_path '/pro'
        expect(page).to have_content 'Organisez une expérience originale'
      end
    end

    context 'user is not logged in' do
      scenario 'user visits root path' do
        visit root_path
        expect(page).to have_current_path '/'
        expect(page).to have_css 'i.co-logo'
        expect(page).to have_content 'Cookoon est une communauté sélective '
      end
    end

  end
end
