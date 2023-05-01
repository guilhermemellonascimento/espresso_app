FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@gmail.com"
    end

    password { 'Ab#123456789' }

    trait :locked do
      locked_at { Time.current }
    end

    trait :with_failed_attempts do
      failed_attempts { 4 }
    end

    trait :with_otp_secret do
      otp_secret { User.generate_otp_secret }
    end

    trait :with_two_factor do
      otp_required_for_login { true }

      after(:build) do |user, _evaluator|
        user.otp_secret = User.generate_otp_secret
      end
    end
  end
end
