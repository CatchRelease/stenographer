# frozen_string_literal: true

FactoryBot.define do
  factory :output, class: Stenographer::Output do
    authentication
    configuration { Faker::Types.complex_rb_hash.to_json }
  end
end
