require 'rails_helper'

describe 'User sign in with two factor authentication' do
  let!(:user) { create(:user, :with_two_factor) }

  context 'with invalid OTP' do
    let!(:user) { create(:user, :with_two_factor) }

    before do
      sign_in_with(user.email, user.password)
    end

    it 'prompts for OTP' do
      expect(page).to have_content 'Insira o token de autenticação gerado pelo aplicativo'
    end

    it 'fill in with an invalid code' do
      fill_in 'user_otp_attempt', with: 'foo'
      click_button 'Entrar'

      expect(page).to have_content 'Código two factor inválido.'
    end
  end

  context 'with valid OTP' do
    before do
      sign_in_with(user.email, user.password)
    end

    it 'prompts for OTP' do
      expect(page).to have_content 'Insira o token de autenticação gerado pelo aplicativo'
    end

    it 'fill in with a valid code' do
      fill_in 'user_otp_attempt', with: user.current_otp
      click_button 'Entrar'

      expect(page).to have_current_path(root_path)
    end
  end
end
