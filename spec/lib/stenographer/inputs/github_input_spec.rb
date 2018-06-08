# frozen_string_literal: true

describe Stenographer::Inputs::GithubInput do
  let(:parser) { Stenographer::Inputs::GithubInput.new }

  describe '#parse' do
    let(:example_response) { File.read("#{Stenographer::Engine.root}/spec/fixtures/github_push_notification.json") }
    let(:master_branch_response) { example_response.gsub('refs/heads/cheetos', 'refs/heads/master') }
    let(:other_branch_response) { example_response.gsub('refs/heads/cheetos', 'refs/heads/buffalobills') }

    def parse_action(params = {})
      parser.parse({payload: master_branch_response}.merge(params))
    end

    describe 'individual behaviors' do
      describe 'no commits' do
        it 'returns an empty array' do
          result = parse_action(payload: {}.to_json)
          expect(result).to eq([])
        end
      end

      describe 'untracked branch' do
        it 'does not create a change configuration' do
          changes = parse_action(payload: other_branch_response)
          expect(changes.length).to equal(0)
        end
      end

      describe 'tracked branch' do
        let(:commit_data) { JSON.parse(master_branch_response, symbolize_names: true) }
        let(:commits) { commit_data[:commits] }

        describe 'use_changelog true' do
          before :each do
            Stenographer.use_changelog = true
          end

          it 'creates Changes for items with changelog' do
            changelog_commits = commits.select { |commit| commit[:message].include?('changelog') }

            changes = parse_action
            expect(changes.length).to eq(changelog_commits.length)
          end

          it 'sets the message from the changelog, not the subject' do
            changes = parse_action

            expect(changes.last[:message]).not_to eq(changes.last[:subject])
          end
        end

        describe 'use_changelog false' do
          before :each do
            Stenographer.use_changelog = false
          end

          it 'creates Changes for all items' do
            changes = parse_action

            expect(changes.length).to eq(commits.length)
          end

          it 'sets the message from the subject if there is no changelog' do
            changes = parse_action

            expect(changes.first[:message]).to eq(changes.first[:subject])
          end
        end
      end
    end
  end
end
