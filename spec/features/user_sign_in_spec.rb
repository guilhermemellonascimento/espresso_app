require 'rails_helper'

describe 'User sign in' do
  let!(:user) { create(:user) }

  context 'with invalid captcha' do
    it 'displays error message' do
      sign_in_with(user.email, user.password)
      expect(page).to have_content 'reCAPTCHA verification failed, please try again.'
    end
  end

  context 'with valid captcha' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:verify_recaptcha).and_return(true)
    end

    context 'with invalid credentials' do
      it 'displays error message' do
        sign_in_with('user@gmail.com', '000000')

        expect(page).to have_content 'Email ou senha inválida.'
      end
    end

    context 'with valid credentials' do
      it 'displays successful login message' do
        sign_in_with(user.email, user.password)

        expect(page).to have_content I18n.t('devise.sessions.signed_in')
      end
    end

    context 'with 5 wrong login attempts' do
      before do
        6.times do
          sign_in_with(user.email, '000000')
        end
      end

      it 'locks the account' do
        user.reload

        expect(user.failed_attempts).to eq(6)
        expect(user.locked_at).not_to be_blank
      end

      it 'sends an email with instructions to unlock the account' do
        user.reload

        expect(ActionMailer::Base.deliveries.count).to eq(1)
        expect(ActionMailer::Base.deliveries[0].subject).to eq(I18n.t('devise.mailer.unlock_instructions.subject'))
      end
    end

    context 'when the account is locked' do
      before do
        6.times do
          sign_in_with(user.email, '000000')
        end
      end

      it 'user can access after 10 minutes' do
        user.reload

        travel_to(user.locked_at + 11.minutes) do
          sign_in_with(user.email, user.password)
          expect(page).to have_content I18n.t('devise.sessions.signed_in')
        end
      end

      it 'user can unlock account via email' do
        user.reload

        open_system_email(user.email, 'Unlock my account')
        expect(page).to have_content I18n.t('devise.unlocks.unlocked')
      end
    end
  end
end
