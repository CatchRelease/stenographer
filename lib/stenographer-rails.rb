# frozen_string_literal: true

require 'will_paginate'
require 'will_paginate-bulma'
require 'groupdate'
require 'redcarpet'
require 'citrus'
require 'http'
require 'omniauth'
require 'omniauth-slack'
require 'sass-rails'

require 'stenographer/engine'
require 'stenographer/inputs/base_input'
require 'stenographer/inputs/github_input'
require 'stenographer/outputs/base_output'
require 'stenographer/outputs/slack_output'
require 'stenographer/routing_constraints/viewer_only'
require 'stenographer/routing_constraints/manager_only'

module Stenographer
  class << self
    mattr_accessor :app_name
    mattr_accessor :app_icon
    mattr_accessor :change_types
    mattr_accessor :viewer
    mattr_accessor :manager
    mattr_accessor :per_page
    mattr_accessor :markdown_renderer
    mattr_accessor :use_changelog
    mattr_accessor :parser
    mattr_accessor :tracked_branches
    mattr_accessor :branch_mapping
    mattr_accessor :link_section_name

    self.app_name = 'Stenographer'
    self.app_icon = nil

    self.change_types = %w[new improved fixed]

    self.viewer = true
    self.manager = true

    self.per_page = 100

    self.markdown_renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)

    self.use_changelog = true

    self.parser = 'Stenographer::Inputs::GithubInput'
    self.tracked_branches = %w[master work]
    self.branch_mapping = { master: 'production', work: 'staging' }
    self.link_section_name = 'Useful Links'
  end

  def self.configure(&block)
    yield self
  end
end
