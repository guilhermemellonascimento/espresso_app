require 'rails_helper'

describe User do
  describe '#enable_two_factor!' do
    let!(:user) { create(:user) }

    it 'enables two factor authentication' do
      expect(user.otp_required_for_login).to be_nil
      user.enable_two_factor!
      expect(user.otp_required_for_login).to be true
    end
  end

  describe '#disable_two_factor!' do
    let!(:user) { create(:user, :with_two_factor, :with_otp_secret) }

    it 'disables two factor authentication' do
      expect(user.otp_required_for_login).to be true
      user.disable_two_factor!
      expect(user.otp_required_for_login).to be false
    end

    it 'removes otp secret' do
      expect(user.otp_secret).to be_present
      user.disable_two_factor!
      expect(user.otp_secret).to be_nil
    end
  end

  describe '#generate_two_factor_secret!' do
    let!(:user) { create(:user) }

    it 'generates otp secret' do
      expect(user.otp_secret).to be_nil
      user.generate_two_factor_secret!
      expect(user.otp_secret).to be_present
    end
  end

  describe '#two_factor_qr_code_uri' do
    let!(:user) { create(:user) }

    it 'returns otp provisioning URI' do
      expect(user.two_factor_qr_code_uri).to be_present
    end
  end
end
