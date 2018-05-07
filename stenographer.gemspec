# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'stenographer/version'

Gem::Specification.new do |s|
  s.name        = 'stenographer'
  s.version     = Stenographer::VERSION
  s.authors     = ['Michael Carey']
  s.email       = ['mike@catchandrelease.com']
  s.homepage    = 'https://github.com/CatchRelease/stenographer'
  s.summary     = 'Better Changelogs'
  s.description = 'Cleaner, Happier, Easier Changelogs in Rails'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'groupdate', '>= 4.0.0'
  s.add_dependency 'rails', '~> 5.2.0'
  s.add_dependency 'will_paginate', '>= 3.1.0'

  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'rails-controller-testing'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'sqlite3'
end
