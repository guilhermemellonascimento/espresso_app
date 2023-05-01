require 'rails_helper'

describe 'Password update' do
  let!(:user) { create(:user) }
  let(:new_password) { Faker::Internet.password(min_length: 12, mix_case: true, special_characters: true) }

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

    context 'when user requests for password update' do
      it 'displays password update page' do
        sign_in_with(user.email, user.password)
        click_link 'Senha'

        expect(page).to have_content 'Atualizar Senha'
      end
    end

    context 'with invalid current password' do
      before do
        sign_in_with(user.email, user.password)
        click_link 'Senha'
        fill_in 'user_current_password', with: 'foo'
        fill_in 'user_password', with: new_password
        click_button 'Atualizar'
      end

      it 'displays error message' do
        expect(page).to have_content 'Current password não é válido'
      end
    end

    context 'with one of the previous passwords' do
      let(:first_password) { Faker::Internet.password(min_length: 12, mix_case: true, special_characters: true) }
      let(:second_password) { Faker::Internet.password(min_length: 12, mix_case: true, special_characters: true) }

      before do
        set_password(user, first_password)
        set_password(user, second_password)
      end

      it 'displays error message' do
        sign_in_with(user.email, user.password)
        fill_in_form('foo', first_password)

        expect(page).to have_content 'Senha foi usada anteriormente'
      end
    end

    context 'with valid data' do
      it 'updates user password' do
        sign_in_with(user.email, user.password)
        fill_in_form(user.password, new_password)

        expect(page).to have_content 'Sua conta foi atualizada com sucesso.'
      end
    end
  end

  def fill_in_form(password, new_password)
    click_link 'Senha'
    fill_in 'user_current_password', with: password
    fill_in 'user_password', with: new_password
    click_button 'Atualizar'
  end
end
