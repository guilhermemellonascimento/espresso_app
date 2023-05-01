class User < ApplicationRecord
  devise :registerable, :recoverable, :rememberable,
         :lockable, :timeoutable, :secure_validatable,
         :password_archivable, :validatable

  devise :two_factor_authenticatable

  def enable_two_factor!
    update!(otp_required_for_login: true)
  end

  def disable_two_factor!
    update!(
      otp_required_for_login: false,
      otp_secret: nil
    )
  end

  def generate_two_factor_secret!
    return unless otp_secret.nil?

    update!(otp_secret: User.generate_otp_secret)
  end

  def two_factor_qr_code_uri
    OtpService.new(self).call
  end
end
