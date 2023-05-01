module Helpers
  def sign_in_with(email, password)
    visit new_user_session_path
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_button 'Entrar'
  end

  def sign_up_with(email, password)
    visit new_user_registration_path
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_button 'Cadastrar'
  end

  def set_password(user, password)
    user.password = password
    user.password_confirmation = password
    user.save!
  end

  def reset_password_with(email)
    visit new_user_password_path

    fill_in 'user_email', with: email
    click_button 'Enviar'
  end

  def open_system_email(email, link)
    open_email(email)
    current_email.click_link link
  end
end
