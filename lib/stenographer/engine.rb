# frozen_string_literal: true

module Stenographer
  class Engine < ::Rails::Engine
    isolate_namespace Stenographer

    config.generators do |g|
      g.test_framework :rspec,
                       fixture: false,
                       view_specs: false,
                       request_specs: false,
                       routing_specs: false

      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
