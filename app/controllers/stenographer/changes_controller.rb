# frozen_string_literal: true

require_dependency 'stenographer/application_controller'

module Stenographer
  class ChangesController < ApplicationController
    skip_before_action :verify_authenticity_token, only: %i[create]

    def create
      parser = Stenographer.parser.constantize.new

      parms = params.permit!
      changes = parser.parse(parms)
      changes.each do |change|
        Change.create_or_update_by_source_id(change)
      end

      head :ok
    end

    def index
      page = params[:page] || 1

      @change_count = Change.where(visible: true).count
      @changes = Change.where(visible: true)
                       .order(created_at: :desc)
                       .paginate(page: page, per_page: Stenographer.per_page)
    end

    def show
      @change = Change.find(params[:id])
    end
  end
end
