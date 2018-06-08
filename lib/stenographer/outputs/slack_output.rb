# frozen_string_literal: true

module Stenographer
  module Outputs
    class SlackOutput < Stenographer::Outputs::BaseOutput
      BASE_URI = 'https://slack.com/api/'

      def channels
        result = get_request(endpoint: 'channels.list', params: { token: token, exclude_archived: true, exclude_members: true })
        channels_data = result[:channels]
        channels_data.map { |channel| [channel[:name], channel[:id]] }
      end

      def send
        raise StandardError, 'you must pass a Change to send' if @change.blank?

        post_json_request(endpoint: 'chat.postMessage', params: {
                            channel: configuration[:channel],
                            text: "Deploying updates to *#{@change.environment.upcase}*:",
                            attachments: [generate_attachment]
                          })
      end

      private

      def configuration
        JSON.parse(@output.configuration, symbolize_names: true)
      end

      def generate_attachment
        note = @change.message

        @change.tracker_ids.split(',').each do |id|
          note += "\n<https://www.pivotaltracker.com/story/show/#{id}|##{id}>"
        end

        {
          'fallback': note,
          'text': note,
          'color': @change.environment == 'production' ? 'good' : 'warning'
        }
      end

      def token
        credentials = @output.authentication.credentials_hash
        credentials[:token]
      end

      def get_request(endpoint: '', params: {})
        response = HTTP.get("#{BASE_URI}/#{endpoint}", params: params)
        JSON.parse(response.body, symbolize_names: true)
      end

      def post_json_request(endpoint: '', params: {})
        response = HTTP
                   .auth("Bearer #{token}")
                   .headers(accept: 'application/json')
                   .post("#{BASE_URI}/#{endpoint}", json: params)
        JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end
