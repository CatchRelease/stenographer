# frozen_string_literal: true

describe Stenographer::AdminsController, type: :controller do
  routes { Stenographer::Engine.routes }

  let!(:first_change) { create(:change, created_at: 2.weeks.ago) }
  let!(:newer_change) { create(:change, created_at: 1.week.ago) }
  let!(:hidden_change) { create(:change, visible: false) }

  describe '#index' do
    def index_action(opts = {})
      get :index, params: {}.merge(opts)
    end

    describe 'individual behaviors' do
      before :each do
        index_action
      end

      describe 'changes' do
        it 'assigns @changes' do
          expect(assigns(:changes)).not_to be_nil
        end

        it 'includes all visible changes' do
          expect(assigns(:changes)).to include(first_change)
          expect(assigns(:changes)).to include(hidden_change)
        end
      end

      describe 'order' do
        it 'created at desc' do
          expect(assigns(:changes)).to match_array([hidden_change, newer_change, first_change])
        end
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

  describe '#edit' do
    def edit_action(opts = {})
      get :edit, params: { id: first_change.id }.merge(opts)
    end

    describe 'individual behaviors' do
      before :each do
        edit_action
      end

      it 'assigns @change' do
        expect(assigns(:change)).to eq(first_change)
      end

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe '#update' do
    def update_action(opts = {})
      get :update, params: { id: first_change.id, change: { tracker_ids: 'hummingbird' } }.merge(opts)
    end

    describe 'individual behaviors' do
      before :each do
        update_action
      end

      it 'updates the record' do
        expect(first_change.reload.tracker_ids).to eq('hummingbird')
      end

      it 'redirects to the admin path' do
        expect(response).to redirect_to(admin_path(first_change))
      end
    end
  end

  describe '#destroy' do
    def destroy_action(opts = {})
      delete :destroy, params: { id: first_change.id }.merge(opts)
    end

    describe 'individual behaviors' do
      it 'destroys the record' do
        expect do
          destroy_action
        end.to change(Stenographer::Change, :count).by(-1)
      end

      it 'redirects to the admin path' do
        destroy_action

        expect(response).to redirect_to(admins_path)
      end
    end
  end
end
