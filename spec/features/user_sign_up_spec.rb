require 'rails_helper'

describe 'User sign up' do
  let!(:user) { build(:user) }

  context 'with invalid captcha' do
    it 'displays error message' do
      sign_up_with(user.email, user.password)
      expect(page).to have_content 'reCAPTCHA verification failed, please try again.'
    end
  end

  context 'with valid captcha' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:verify_recaptcha).and_return(true)
    end

    context 'with valid email, password and password confirmation' do
      it 'displays successful sign up message' do
        sign_up_with(user.email, user.password)

        expect(page).to have_content I18n.t('devise.registrations.signed_up')
        expect(page).to have_current_path(root_path)
      end
    end

    context 'with invalid email' do
      it 'displays error message' do
        sign_up_with('foo', '000000')

        expect(page).to have_content('Email não é válido')
      end
    end

    context 'with an email already registered' do
      let!(:registered_user) { create(:user) }

      it 'displays error message' do
        sign_up_with(registered_user.email, registered_user.password)

        expect(page).to have_content 'Email já está em uso'
      end
    end
  end
end
