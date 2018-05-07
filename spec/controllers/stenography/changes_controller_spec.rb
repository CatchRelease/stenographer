# frozen_string_literal: true

describe Stenographer::ChangesController, type: :controller do
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

        it 'includes only visible changes' do
          expect(assigns(:changes)).to include(first_change)
          expect(assigns(:changes)).not_to include(hidden_change)
        end
      end

      describe 'order' do
        it 'created at desc' do
          expect(assigns(:changes)).to match_array([newer_change, first_change])
        end
      end

      it 'renders the index page' do
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
