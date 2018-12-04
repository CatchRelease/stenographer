# frozen_string_literal: true

module Stenographer
  class Link < ApplicationRecord
    validates :url, presence: true
  end
end
