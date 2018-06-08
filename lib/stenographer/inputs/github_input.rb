# frozen_string_literal: true

# https://developer.github.com/webhooks/
# https://developer.github.com/v3/activity/events/types/#pushevent
module Stenographer
  module Inputs
    class GithubInput
      include Stenographer::Inputs::BaseInput

      GRAMMAR = File.join(Stenographer::Engine.root, 'lib/stenographer/commit_message_parser')
      COMMIT_MESSAGE_PARSER = Citrus.load(GRAMMAR).first

      def parse(params)
        changes = []
        notification = JSON.parse(params[:payload], symbolize_names: true)
        commits = notification[:commits]

        return changes if commits.blank?

        branch = notification[:ref].split('/').last

        if tracked_branch?(branch)
          commits.each do |commit|
            message = commit_message(commit)
            subject = message.lines.first.strip
            changelog_message = parse_changelog_message(message)
            tracker_ids = parse_tracker_ids(message)

            next if Stenographer.use_changelog && changelog_message.blank?

            displayed_message = if Stenographer.use_changelog
                                  changelog_message
                                elsif changelog_message.present?
                                  changelog_message
                                else
                                  subject
                                end

            changes << {
              subject: subject,
              message: displayed_message,
              visible: true,
              environment: branch_to_environment(branch),
              tracker_ids: tracker_ids.join(', '),
              source: commit.to_json
            }
          end
        end

        changes
      end

      private

      def branch_to_environment(branch)
        Stenographer.branch_mapping[branch.to_sym].presence || branch
      end

      def tracked_branch?(branch)
        if Stenographer.tracked_branches.blank?
          true
        else
          Stenographer.tracked_branches.include?(branch)
        end
      end

      def parse_changelog_message(commit)
        regex = /\[changelog (.*)\]/i

        match = commit.match(regex)

        match.present? ? match[1] : nil
      end

      def commit_message(commit)
        commit[:message]
      end

      def parse_tracker_ids(commit)
        parsed = suppress(Citrus::ParseError) do
          COMMIT_MESSAGE_PARSER.parse(commit)
        end

        parsed&.value
      end
    end
  end
end
