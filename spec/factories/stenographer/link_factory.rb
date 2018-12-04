# frozen_string_literal: true

FactoryBot.define do
  factory :link, class: Stenographer::Link do
    url { Faker::Internet.url }
    description { Faker::Community.quotes }
  end
end
