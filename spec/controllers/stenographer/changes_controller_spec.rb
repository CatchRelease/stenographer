# frozen_string_literal: true

describe Stenographer::ChangesController, type: :controller do
  routes { Stenographer::Engine.routes }

  let!(:first_change) { create(:change, created_at: 2.weeks.ago, environment: 'env1') }
  let!(:newer_change) { create(:change, created_at: 1.week.ago, environment: 'env2') }
  let!(:hidden_change) { create(:change, visible: false) }

  describe '#create' do
    let(:example_response) { File.read("#{Stenographer::Engine.root}/spec/fixtures/github_push_notification.json") }
    let(:master_branch_response) { example_response.gsub('refs/heads/cheetos', 'refs/heads/master') }

    def create_action(params = {})
      post :create, params: { payload: master_branch_response }.merge(params)
    end

    describe 'individual behaviors' do
      it 'responds successfully' do
        create_action

        expect(response).to be_successful
      end

      describe 'use_changelog false' do
        before :each do
          Stenographer.use_changelog = false
        end

        it 'creates Changes for all items' do
          commits = JSON.parse(master_branch_response, symbolize_names: true)[:commits]

          expect do
            create_action
          end.to change(Stenographer::Change, :count).by(commits.length)
        end
      end
    end
  end

  describe '#index' do
    def index_action(opts = {})
      get :index, params: {}.merge(opts)
    end

    describe 'individual behaviors' do
      describe 'changes' do
        before :each do
          index_action(environment: 'all')
        end

        it 'assigns @changes' do
          expect(assigns(:changes)).not_to be_nil
        end

        it 'includes only visible changes' do
          expect(assigns(:changes)).to include(first_change)
          expect(assigns(:changes)).not_to include(hidden_change)
        end
      end

      describe 'order' do
        before :each do
          index_action(environment: 'all')
        end

        it 'created at desc' do
          expect(assigns(:changes)).to match_array([newer_change, first_change])
        end
      end

      describe 'environment filter' do
        let!(:default_change) { create(:change, environment: Stenographer.default_environment) }

        describe 'default' do
          before :each do
            index_action
          end

          it 'returns default environment changes' do
            expect(assigns(:changes).length).to eq(Stenographer::Change.where(visible: true, environment: Stenographer.default_environment).length)
          end
        end

        describe 'all' do
          before :each do
            index_action(environment: 'all')
          end

          it 'returns all visible changes' do
            expect(assigns(:changes).length).to eq(Stenographer::Change.where(visible: true).length)
          end
        end

        describe 'filtered' do
          before :each do
            index_action(environment: 'env2')
          end

          it 'returns changes with a matching environment' do
            expect(assigns(:changes).length).to eq(Stenographer::Change.where(visible: true, environment: 'env2').length)
          end
        end
      end

      it 'renders the index page' do
        index_action(environment: 'all')

        expect(response).to render_template(:index)
      end
    end
  end

  describe '#show' do
    def show_action(opts = {})
      get :show, params: { id: first_change.id }.merge(opts)
    end

    describe 'individual behaviors' do
      before :each do
        show_action
      end

      it 'assigns @change' do
        expect(assigns(:change)).to eq(first_change)
      end

      it 'renders the show page' do
        expect(response).to render_template(:show)
      end
    end
  end
end
