# frozen_string_literal: true

require_dependency 'stenographer/application_controller'

module Stenographer
  class Admin::AuthenticationsController < ApplicationController
    before_action :assign_authentication, only: %i[show destroy]

    def index
      @slack_authentication = Authentication.find_by(provider: 'slack')

      page = params[:page] || 1
      @authentications = Authentication.order(id: :desc).paginate(page: page, per_page: Stenographer.per_page)
    end

    def show; end

    def destroy
      if @authentication.destroy
        redirect_to admin_authentications_path, notice: 'Authentication Destroyed'
      else
        redirect_to admin_authentication_path(@authentication), alert: @authentication.errors.full_messages.to_sentence
      end
    end

    private

    def assign_authentication
      @authentication = Authentication.find(params[:id])
    end
  end
end
