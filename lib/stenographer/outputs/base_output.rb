# frozen_string_literal: true

module Stenographer
  module Outputs
    class BaseOutput
      def initialize(change: nil, output: nil)
        raise StandardError, 'you must pass the Output' if output.blank?
        @change = change
        @output = output
      end

      def send
        raise StandardError, 'implement me'
      end
    end
  end
end
