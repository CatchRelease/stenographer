# frozen_string_literal: true

FactoryBot.define do
  factory :change, class: Stenographer::Change do
    message { Faker::HitchhikersGuideToTheGalaxy.quote }
    visible { Faker::Boolean.boolean }
    change_type { Stenographer::Change::VALID_CHANGE_TYPES.sample }
    environments { Faker::Movies::StarWars.planet }
    tracker_ids { '#56789' }
    source { '{}' }
  end
end
