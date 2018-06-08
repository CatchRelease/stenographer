# frozen_string_literal: true

module Stenographer
  class Output < ApplicationRecord
    validates :authentication_id, presence: true
    validates :configuration, presence: true

    belongs_to :authentication, class_name: 'Stenographer::Authentication'

    def configuration_hash
      configuration.present? ? JSON.parse(configuration, symbolize_names: true) : {}
    end

    def filters_hash
      filters.present? ? JSON.parse(filters, symbolize_names: true) : {}
    end

    def provider
      authentication.provider
    end
  end
end
