require 'rails_helper'

describe OtpService do
  describe '#call' do
    let!(:user) { create(:user, :with_otp_secret) }

    it 'returns provisioning URI' do
      expect(
        described_class.new(user).call
      ).not_to eq("otpauth://totp/#{user.email}?secret=#{user.otp_secret}")
    end
  end
end
