# frozen_string_literal: true

describe Stenographer::Outputs::SlackOutput do
  let!(:output) { create(:output) }
  let!(:change) { create(:change) }
  let(:slack) { described_class.new(change: change, output: output) }

  # before :each do
  #   allow(HTTP).to receive(:post)
  #   allow(HTTP).to receive(:get)
  # end

  class SlackResponse
    attr_accessor :body
  end

  describe '#channels' do
    let(:channels_response) { File.read("#{Stenographer::Engine.root}/spec/fixtures/slack_channels_list.json") }

    before do
      response = SlackResponse.new
      response.body = channels_response
      allow(HTTP).to receive(:get).and_return(response)
    end

    it 'makes an http get request' do
      expect(HTTP).to receive(:get)
      slack.channels
    end

    it 'returns the channels' do
      expect(slack.channels.length).to eq(2)
    end
  end

  describe '#send' do
    let(:chat_post_message_response) { File.read("#{Stenographer::Engine.root}/spec/fixtures/slack_chat_post_message.json") }

    before do
      response = SlackResponse.new
      response.body = chat_post_message_response
      allow(HTTP).to receive_message_chain(:auth, :headers, :post).and_return(response)
    end

    it 'makes an http post request' do
      expect(HTTP).to receive_message_chain(:auth, :headers, :post)
      slack.send
    end

    it 'returns the sent messages' do
      expect(slack.send[:ok]).to be_truthy
    end
  end
end
