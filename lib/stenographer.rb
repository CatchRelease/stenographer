# frozen_string_literal: true

require 'will_paginate'
require 'groupdate'
require 'redcarpet'

require 'stenographer/engine'
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
    mattr_accessor :default_environment
    mattr_accessor :markdown_renderer

    self.app_name = 'Stenographer'
    self.app_icon = nil

    self.change_types = %w[new improved fixed]

    self.viewer = true
    self.manager = true

    self.per_page = 100
    self.default_environment = 'production'

    self.markdown_renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
  end

  def self.configure(&block)
    yield self
  end
end
