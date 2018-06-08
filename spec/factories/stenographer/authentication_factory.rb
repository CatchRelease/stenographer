# frozen_string_literal: true

FactoryBot.define do
  factory :authentication, class: Stenographer::Authentication do
    provider Faker::Pokemon.name
    uid Faker::Crypto.md5
    credentials { { token: '1234' }.to_json }
  end
end
