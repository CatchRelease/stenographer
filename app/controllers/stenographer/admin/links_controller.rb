# frozen_string_literal: true

require_dependency 'stenographer/application_controller'

module Stenographer
  class Admin::LinksController < ApplicationController
    before_action :assign_link, only: %i[show edit update destroy]

    def new
      @link = Link.new
    end

    def create
      @link = Link.new(link_params)

      if @link.save
        redirect_to admin_link_path(@link), notice: 'Link Created'
      else
        flash.now[:alert] = @link.errors.full_messages.to_sentence
        render :new
      end
    end

    def index
      page = params[:page] || 1
      @links = Link.order(created_at: :desc).paginate(page: page, per_page: Stenographer.per_page)
    end

    def show; end

    def edit; end

    def update
      message = {}

      if @link.update(link_params)
        message[:notice] = 'Link Updated'

        redirect_to admin_link_path(@link), message
      else
        flash.now[:alert] = @link.errors.full_messages.to_sentence
        render :edit
      end
    end

    def destroy
      if @link.destroy
        redirect_to admin_links_path, notice: 'Link Destroyed'
      else
        redirect_to admin_link_path(@link), alert: @link.errors.full_messages.to_sentence
      end
    end

    private

    def link_params
      params.require(:link).permit(:url, :description)
    end

    def assign_link
      @link = Link.find(params[:id])
    end
  end
end
