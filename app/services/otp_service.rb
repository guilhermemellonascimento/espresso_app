class OtpService
  def initialize(user)
    @user = user
  end

  def call
    qr_code_link
  end

  private

  def totp
    ROTP::TOTP.new(@user.otp_secret)
  end

  def qr_code_link
    totp.provisioning_uri(@user.email)
  end
end
