# frozen_string_literal: true

require_dependency 'stenographer/application_controller'

module Stenographer
  class Admin::OutputsController < ApplicationController
    include Stenographer::OutputsHelper

    before_action :assign_output, only: %i[show edit update destroy]

    def index
      @authentication_count = Authentication.count
      @providers = Authentication.providers

      page = params[:page] || 1
      @outputs = Output.order(id: :desc).paginate(page: page, per_page: Stenographer.per_page)
    end

    def show; end

    def new
      authentication_id = params[:output][:authentication_id]
      @authentication = Authentication.find_by(id: authentication_id)

      if @authentication.present?
        @output = Output.new(authentication_id: authentication_id)
      else
        redirect_to admin_outputs_path, alert: 'Cannot create an Output without a Provider'
      end
    end

    def create
      @output = Output.new(output_params)
      @output.configuration = params[:configuration].to_json
      @output.filters = params[:filters].to_json

      if @output.save
        redirect_to admin_output_path(@output), notice: 'Output Created'
      else
        redirect_to admin_outputs_path, alert: @output.errors.full_messages.to_sentence
      end
    end

    def edit
      @authentication = @output.authentication
    end

    def update
      @output.configuration = params[:configuration].to_json
      @output.filters = params[:filters].to_json

      if @output.save
        redirect_to admin_output_path(@output), notice: 'Output Created'
      else
        redirect_to admin_outputs_path, alert: @output.errors.full_messages.to_sentence
      end
    end

    def destroy
      if @output.destroy
        redirect_to admin_outputs_path, notice: 'Output Destroyed'
      else
        redirect_to admin_output_path(@output), alert: @output.errors.full_messages.to_sentence
      end
    end

    private

    def assign_output
      @output = Output.find(params[:id])
    end

    def output_params
      params.require(:output).permit(:authentication_id)
    end
  end
end
