# frozen_string_literal: true

describe Stenographer::Admin::OutputsController, type: :controller do
  routes { Stenographer::Engine.routes }

  let!(:authentication) { create(:authentication) }
  let!(:first_output) { create(:output, created_at: 2.weeks.ago) }
  let!(:newer_output) { create(:output, created_at: 1.week.ago) }

  describe '#index' do
    def index_action(opts = {})
      get :index, params: {}.merge(opts)
    end

    describe 'individual behaviors' do
      before :each do
        index_action
      end

      describe 'changes' do
        it 'assigns @authentication_count' do
          expect(assigns(:authentication_count)).to eq(Stenographer::Authentication.count)
        end

        it 'assigns @providers' do
          expect(assigns(:providers)).to eq(Stenographer::Authentication.all.map(&:provider).uniq)
        end

        it 'assigns @outputs' do
          expect(assigns(:outputs)).not_to be_nil
        end

        it 'includes all outputs' do
          expect(assigns(:outputs).length).to eq(Stenographer::Output.count)
        end
      end

      describe 'order' do
        it 'id desc' do
          expect(assigns(:outputs)).to match_array([newer_output, first_output])
        end
      end
    end
  end

  describe '#show' do
    def show_action(opts = {})
      get :show, params: { id: first_output.id }.merge(opts)
    end

    describe 'individual behaviors' do
      before :each do
        show_action
      end

      it 'assigns @output' do
        expect(assigns(:output)).to eq(first_output)
      end

      it 'renders the show page' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe '#new' do
    def new_action(opts = {})
      get :new, params: { output: { authentication_id: authentication.id } }.merge(opts)
    end

    describe 'individual behaviors' do
      before :each do
        new_action
      end

      it 'assigns @authentication' do
        expect(assigns(:authentication)).not_to be_nil
      end

      it 'assigns @output' do
        expect(assigns(:output)).not_to be_nil
        expect(assigns(:output).authentication_id).not_to be_nil
      end

      it 'renders the new page' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#create' do
    let(:configuration) { { stuff: '1', other_stuff: '2' } }

    def create_action(opts = {})
      post :create, params: { output: { authentication_id: authentication.id }, configuration: configuration }.merge(opts)
    end

    describe 'individual behaviors' do
      describe 'success' do
        it 'creates the record' do
          expect do
            create_action
          end.to change(Stenographer::Output, :count).by(1)
        end

        it 'sets the authentication' do
          create_action

          expect(Stenographer::Output.last.authentication).to eq(authentication)
        end

        it 'sets the configuration' do
          create_action
          output_configuration = Stenographer::Output.last.configuration_hash

          expect(output_configuration[:stuff]).to eq(configuration[:stuff])
          expect(output_configuration[:other_stuff]).to eq(configuration[:other_stuff])
        end

        it 'redirects to the admin path' do
          create_action

          expect(response).to redirect_to(admin_output_path(Stenographer::Output.last))
        end
      end

      describe 'failure' do
        it 'does not create the record' do
          expect do
            create_action(output: { authentication_id: nil })
          end.not_to change(Stenographer::Output, :count)
        end

        it 'redirects to the admin path' do
          create_action(output: { authentication_id: nil })

          expect(response).to redirect_to(admin_outputs_path)
        end
      end
    end
  end

  describe '#edit' do
    def edit_action(opts = {})
      get :edit, params: { id: first_output.id }.merge(opts)
    end

    describe 'individual behaviors' do
      before :each do
        edit_action
      end

      it 'assigns @output' do
        expect(assigns(:output)).to eq(first_output)
      end

      it 'assigns @authentication' do
        expect(assigns(:authentication)).to eq(first_output.authentication)
      end

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe '#update' do
    let(:configuration) { { stuff: '3', other_stuff: '4' } }

    def update_action(opts = {})
      patch :update, params: { id: first_output.id, configuration: configuration }.merge(opts)
    end

    describe 'individual behaviors' do
      before :each do
        update_action
      end

      it 'updates the record' do
        output_configuration = first_output.reload.configuration_hash
        expect(output_configuration[:stuff]).to eq(configuration[:stuff])
      end

      it 'redirects to the admin output path' do
        expect(response).to redirect_to(admin_output_path(first_output))
      end
    end
  end

  describe '#destroy' do
    def destroy_action(opts = {})
      delete :destroy, params: { id: first_output.id }.merge(opts)
    end

    describe 'individual behaviors' do
      it 'destroys the record' do
        expect do
          destroy_action
        end.to change(Stenographer::Output, :count).by(-1)
      end

      it 'redirects to the admin path' do
        destroy_action

        expect(response).to redirect_to(admin_outputs_path)
      end
    end
  end
end
