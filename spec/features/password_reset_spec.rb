require 'rails_helper'

describe 'Password reset' do
  let!(:user) { create(:user) }
  let(:new_password) { Faker::Internet.password(min_length: 12, mix_case: true, special_characters: true) }

  context 'when user requests for password reset' do
    it 'sends an email with instructions' do
      reset_password_with(user.email)

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(page).to have_content I18n.t('devise.passwords.send_paranoid_instructions')
    end
  end

  context 'when user resets his password' do
    before do
      reset_password_with(user.email)
      open_system_email(user.email, 'Change my password')
    end

    context 'with valid password' do
      it 'updates user password' do
        fill_in 'user_password', with: new_password
        fill_in 'user_password_confirmation', with: new_password
        click_button 'Atualizar'

        expect(page).to have_content 'Sua senha foi alterada com sucesso. Você está logado.'
      end
    end

    context 'with the current password' do
      before do
        reset_password_with(user.email)
        open_system_email(user.email, 'Change my password')
      end

      it 'displays error message' do
        fill_in 'user_password', with: user.password
        fill_in 'user_password_confirmation', with: user.password
        click_button 'Atualizar'

        expect(page).to have_content 'Deve ser diferente da senha atual.'
      end
    end

    context 'with one of the previous passwords' do
      let(:first_password) { Faker::Internet.password(min_length: 12, mix_case: true, special_characters: true) }
      let(:second_password) { Faker::Internet.password(min_length: 12, mix_case: true, special_characters: true) }

      before do
        set_password(user, first_password)
        set_password(user, second_password)

        reset_password_with(user.email)
        open_system_email(user.email, 'Change my password')
      end

      it 'displays error message' do
        fill_in 'user_password', with: first_password
        fill_in 'user_password_confirmation', with: first_password
        click_button 'Atualizar'

        expect(page).to have_content 'Password foi usada anteriormente'
      end
    end
  end
end
