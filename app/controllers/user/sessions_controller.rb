# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  include TwoFactorAuthenticate

  prepend_before_action :check_captcha,
                        only: [:create],
                        unless: -> { params[:two_factor].present? }

  prepend_before_action :authenticate_with_otp_two_factor,
                        if: -> { action_name == 'create' && otp_two_factor_enabled? }

  private

  def check_captcha
    return if verify_recaptcha

    self.resource = resource_class.new sign_in_params

    respond_with_navigational(resource) do
      flash.discard(:recaptcha_error)
      render :new
    end
  end
end
