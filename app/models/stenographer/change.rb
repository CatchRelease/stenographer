# frozen_string_literal: true

module Stenographer
  class Change < ApplicationRecord
    VALID_CHANGE_TYPES = Stenographer.change_types

    validates :message, presence: true
    validates :change_type, inclusion: { in: VALID_CHANGE_TYPES }
  end
end
