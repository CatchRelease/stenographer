# frozen_string_literal: true

require_dependency 'stenographer/application_controller'

module Stenographer
  class ChangesController < ApplicationController
    def index
      page = params[:page] || 1
      environment = params[:environment].presence

      changes = if environment == 'all'
                  Change
                elsif valid_environment?
                  Change.where(environment: params[:environment])
                else
                  Change.where(environment: Stenographer.default_environment)
                end

      @changes = changes.where(visible: true)
                        .order(created_at: :desc)
                        .paginate(page: page, per_page: Stenographer.per_page)
    end

    def show
      @change = Change.find(params[:id])
    end

    private

    def valid_environment?
      params[:environment].present? && Stenographer::Change.environments.include?(params[:environment])
    end
  end
end
