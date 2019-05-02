# frozen_string_literal: true

module Stenographer
  class Change < ApplicationRecord
    VALID_CHANGE_TYPES = Stenographer.change_types

    before_save :sanitize_environment
    after_commit :send_to_outputs, on: [:create]
    after_update :send_to_outputs, if: proc { |change| change.saved_change_to_environments? }

    validates :message, presence: true
    validates :change_type, inclusion: { in: VALID_CHANGE_TYPES }, allow_nil: true

    def sanitize_environment
      if environments.present?
        environments_array = environments.split(',').map do |environment|
          environment.downcase.strip
        end
        environments_array.uniq!
        environments_array.join(', ')
      end
    end

    def to_markdown(truncate: nil)
      msg = truncate ? message.truncate(truncate) : message
      Stenographer.markdown_renderer.render(msg).html_safe
    end

    def matches_filters(output = nil)
      return false if output.blank?

      filters = output.filters_hash
      return true if filters.empty?

      filters.none? do |key, value|
        if value.present? && key == :environments
          environments_array = environments.split(',').map(&:strip)
          environments_array.last != value.strip
        else
          value.present? && send(key) != value
        end
      end
    end

    def environments_to_tags
      tags = []

      environment_array = environments.split(',').map(&:strip)
      environment_array.each do |environment|
        tags << {
          name: environment.capitalize,
          color: environment == 'production' ? 'is-primary' : 'is-light'
        }
      end

      tags
    end

    def self.create_or_update_by_source_id(change_params)
      source_id = change_params[:source_id]

      if source_id.present? && (change = Change.find_by(source_id: source_id)).present?
        change.environments += ", #{change_params[:environments]}"
        change.save
      else
        Change.create(change_params)
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
