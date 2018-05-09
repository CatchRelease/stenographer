# frozen_string_literal: true

require_dependency 'stenographer/application_controller'

module Stenographer
  class AdminsController < ApplicationController
    before_action :assign_change, only: %i[show edit update destroy]

    def new
      @change = Change.new
    end

    def create
      @change = Change.new(change_params)
      @change.environment = Rails.env.to_s

      if @change.save
        redirect_to admin_path(@change), notice: 'Change Created'
      else
        flash.now[:alert] = @change.errors.full_messages.to_sentence
        render :new
      end
    end

    def index
      page = params[:page] || 1
      @changes = Change.order(created_at: :desc).paginate(page: page, per_page: Stenographer.per_page)
    end

    def show; end

    def edit; end

    def update
      message = {}

      if @change.update(change_params)
        message[:notice] = 'Change Updated'

        redirect_to admin_path(@change), message
      else
        flash.now[:alert] = @change.errors.full_messages.to_sentence
        render :edit
      end
    end

    def destroy
      if @change.destroy
        redirect_to admins_path, notice: 'Change Destroyed'
      else
        redirect_to admin_path(@change), alert: @change.errors.full_messages.to_sentence
      end
    end

    private

    def change_params
      params.require(:change).permit(:created_at, :message, :visible, :change_type, :environment, :tracker_ids)
    end

    def assign_change
      @change = Change.find(params[:id])
    end
  end
end
