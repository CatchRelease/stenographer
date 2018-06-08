# frozen_string_literal: true

require_dependency 'stenographer/application_controller'

module Stenographer
  class AuthenticationsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      auth_hash = request.env['omniauth.auth']
      @hash = auth_hash

      Authentication.find_or_create_by(provider: auth_hash.provider) do |authentication|
        authentication.uid = auth_hash.uid
        authentication.credentials = auth_hash.credentials.present? ? auth_hash.credentials.to_json : nil
        authentication.source = auth_hash.to_json
      end

      flash[:notice] = 'Successfully created the Authentication'
      redirect_to admin_authentications_path
    end

    def failure; end
  end
end
