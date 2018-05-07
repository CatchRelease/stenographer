# frozen_string_literal: true

require 'stenographer/engine'
require 'stenographer/routing_constraints/viewer_only'
require 'stenographer/routing_constraints/manager_only'

# require './generators/stenography/install_generator'

module Stenographer
  class << self
    mattr_accessor :app_name
    mattr_accessor :app_icon
    mattr_accessor :change_types
    mattr_accessor :viewer
    mattr_accessor :manager

    self.app_name = 'Stenographer'
    self.app_icon = nil

    self.change_types = %w[new improved fixed]

    self.viewer = true
    self.manager = true
  end

  def self.configure(&block)
    yield self
  end
end
