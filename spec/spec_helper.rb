# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('dummy/config/environment.rb', __dir__)
require 'rspec/rails'

require 'rails-controller-testing'
require 'shoulda'
require 'shoulda-matchers'
require 'faker'
require 'factory_bot_rails'
require 'will_paginate'
require 'will_paginate/active_record'

require 'support/factory_bot'

Rails.backtrace_cleaner.remove_silencers!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'

  # rails-controller-testing does not work automatically with engines
  %i[controller view request].each do |type|
    config.include ::Rails::Controller::Testing::TestProcess, type: type
    config.include ::Rails::Controller::Testing::TemplateAssertions, type: type
    config.include ::Rails::Controller::Testing::Integration, type: type
  end
end
