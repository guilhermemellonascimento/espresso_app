require 'rails_helper'

describe 'Dashboard' do
  let!(:user) { create(:user) }

  context 'when user is without activity for 5 minutes' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:verify_recaptcha).and_return(true)
      sign_in_with(user.email, user.password)
    end

    it 'redirects the user to login page' do
      travel_to(5.minutes.from_now) do
        visit current_path

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_content I18n.t('devise.failure.timeout')
      end
    end
  end
end
