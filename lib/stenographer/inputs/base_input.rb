# frozen_string_literal: true

module Stenographer
  module Inputs
    module BaseInput
      # Returns an array of changes, i.e. [{ subject: String, message: String, visible: Boolean, environment: String, tracker_ids: String, source: String}]
      def parse(params)
        raise StandardError, 'implement me'
      end
    end
  end
end
