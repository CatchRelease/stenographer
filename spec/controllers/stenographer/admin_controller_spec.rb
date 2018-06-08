# frozen_string_literal: true

describe Stenographer::AdminController, type: :controller do
  routes { Stenographer::Engine.routes }

  describe '#index' do
    def index_action(opts = {})
      get :index, params: {}.merge(opts)
    end

    describe 'individual behaviors' do
      let!(:change) { create(:change) }
      let!(:authentication) { create(:authentication) }

      before :each do
        index_action(environment: 'all')
      end

      it 'assigns @change_count' do
        expect(assigns(:change_count)).to eq(Stenographer::Change.count)
      end

      it 'assigns @authentication_count' do
        expect(assigns(:authentication_count)).to eq(Stenographer::Authentication.count)
      end

      it 'renders the index page' do
        index_action

        expect(response).to render_template(:index)
      end
    end
  end
end
