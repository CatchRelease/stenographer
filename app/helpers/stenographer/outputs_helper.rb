# frozen_string_literal: true

module Stenographer
  module OutputsHelper
    def slack_channels(output)
      slack_output = Stenographer::Outputs::SlackOutput.new(output: output)
      slack_output.channels
    end
  end
end
