# frozen_string_literal: true

require_dependency 'stenographer/application_controller'

module Stenographer
  class ChangesController < ApplicationController
    def index
      page = params[:page] || 1
      @changes = Change.where(visible: true).order(created_at: :desc).paginate(page: page, per_page: 25)
    end

    def show
      @change = Change.find(params[:id])
    end
  end
end
