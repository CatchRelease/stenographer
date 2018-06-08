# frozen_string_literal: true

module Stenographer
  class Authentication < ApplicationRecord
    validates :provider, presence: true
    validates :uid, presence: true

    has_many :outputs, class_name: 'Stenographer::Output', dependent: :destroy

    def self.providers
      distinct(:provider).pluck(:provider)
    end

    def credentials_hash
      credentials.present? ? JSON.parse(credentials, symbolize_names: true) : {}
    end
  end
end
