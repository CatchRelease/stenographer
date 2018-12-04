# frozen_string_literal: true

require_dependency 'stenographer/application_controller'

module Stenographer
  class AdminController < ApplicationController
    def index
      @change_count = Change.count
      @authentication_count = Authentication.count
      @output_count = Output.count
      @link_count = Link.count
    end
  end
end
