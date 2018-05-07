# frozen_string_literal: true

require 'rails/generators'

module Stenographer
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Create Stenographer base files'
      source_root File.expand_path('templates', __dir__)

      def add_initializer
        path = "#{Rails.root}/config/initializers/stenographer.rb"

        if File.exist?(path)
          puts 'Skipping config/initializers/stenographer.rb creation, as file already exists!'
        else
          puts 'Adding Stenographer initializer (config/initializers/stenographer.rb)...'

          template 'config/initializers/stenographer.rb', path
        end
      end

      def add_routes
        route 'mount Stenographer::Engine, at: "/stenographer"'
      end

      def add_migrations
        exec('rake stenographer:install:migrations')
      end
    end
  end
end
