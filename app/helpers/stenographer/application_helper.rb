# frozen_string_literal: true

module Stenographer
  module ApplicationHelper
    def app_name
      Stenographer.app_name
    end

    def app_icon?
      Stenographer.app_icon.present?
    end

    def app_icon
      Stenographer.app_icon
    end

    def manager?
      Stenographer.manager.respond_to?(:call) ? Stenographer.manager.call(session) : Stenographer.manager
    end

    def environment_link_class(environment)
      if params[:environment].present? && params[:environment] == environment
        'active'
      elsif params[:environment].nil? && environment == Stenographer.default_environment
        'active'
      else
        ''
      end
    end
  end
end
