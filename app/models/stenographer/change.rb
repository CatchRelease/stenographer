# frozen_string_literal: true

module Stenographer
  class Change < ApplicationRecord
    VALID_CHANGE_TYPES = Stenographer.change_types

    before_save :sanitize_environment

    validates :message, presence: true
    validates :change_type, inclusion: { in: VALID_CHANGE_TYPES }, allow_nil: true

    def sanitize_environment
      environment.present? ? environment.downcase.strip : nil
    end

    def self.environments
      ['all'] + distinct(:environment).pluck(:environment)
    end

    def to_markdown
      Stenographer.markdown_renderer.render(message).html_safe
    end
  end
end
