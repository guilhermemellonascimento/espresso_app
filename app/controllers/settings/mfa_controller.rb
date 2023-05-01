class Settings::MfaController < ApplicationController
  before_action :authenticate_user!

  def new
    current_user.generate_two_factor_secret!
  end

  def create
    if current_user.validate_and_consume_otp!(two_fa_params[:code])
      current_user.enable_two_factor!

      flash[:notice] = 'Two factor authentication habilitado.'
      redirect_to settings_mfa_path
    else
      flash.now[:alert] = 'Código incorreto.'
      render :new
    end
  end

  def destroy
    return unless current_user.disable_two_factor!

    flash[:notice] = 'Two factor authentication desabillitado.'
    redirect_to action: :index
  end

  private

  def two_fa_params
    params.require(:two_fa).permit(:code)
  end
end
