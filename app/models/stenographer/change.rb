# frozen_string_literal: true

module Stenographer
  class Change < ApplicationRecord
    VALID_CHANGE_TYPES = Stenographer.change_types

    before_save :sanitize_environment
    after_commit :send_to_outputs, on: [:create]

    validates :message, presence: true
    validates :change_type, inclusion: { in: VALID_CHANGE_TYPES }, allow_nil: true

    def sanitize_environment
      environment.present? ? environment.downcase.strip : nil
    end

    def self.environments
      ['all'] + distinct(:environment).pluck(Arel.sql('lower(environment)'))
    end

    def to_markdown
      Stenographer.markdown_renderer.render(message).html_safe
    end

    def matches_filters(output = nil)
      return false if output.blank?

      filters = output.filters_hash
      return true if filters.empty?

      filters.none? do |key, value|
        send(key) != value
      end
    end

    private

    def send_to_outputs
      unless Rails.env.test?
        Output.all.find_each do |output|
          if matches_filters(output)
            output_class = "Stenographer::Outputs::#{output.authentication.provider.classify}Output".constantize
            sender = output_class.new(output: output, change: self)
            sender.send
          end
        end
      end
    end
  end
end
