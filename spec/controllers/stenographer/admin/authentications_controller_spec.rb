# frozen_string_literal: true

describe Stenographer::Admin::AuthenticationsController, type: :controller do
  routes { Stenographer::Engine.routes }

  let!(:first_authentication) { create(:authentication, provider: 'slack', created_at: 2.weeks.ago) }
  let!(:newer_authentication) { create(:authentication, created_at: 1.week.ago) }

  describe '#index' do
    def index_action(opts = {})
      get :index, params: {}.merge(opts)
    end

    describe 'individual behaviors' do
      before :each do
        index_action
      end

      describe 'changes' do
        it 'assigns @slack_authentication' do
          expect(assigns(:slack_authentication)).not_to be_nil
        end

        it 'assigns @authentications' do
          expect(assigns(:authentications)).not_to be_nil
        end

        it 'includes all authentications' do
          expect(assigns(:authentications).length).to eq(Stenographer::Authentication.count)
        end
      end

      describe 'order' do
        it 'created at desc' do
          expect(assigns(:authentications)).to match_array([newer_authentication, first_authentication])
        end
      end
    end
  end

  describe '#show' do
    def show_action(opts = {})
      get :show, params: { id: first_authentication.id }.merge(opts)
    end

    describe 'individual behaviors' do
      before :each do
        show_action
      end

      it 'assigns @change' do
        expect(assigns(:authentication)).to eq(first_authentication)
      end

      it 'renders the show page' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe '#destroy' do
    def destroy_action(opts = {})
      delete :destroy, params: { id: first_authentication.id }.merge(opts)
    end

    describe 'individual behaviors' do
      it 'destroys the record' do
        expect do
          destroy_action
        end.to change(Stenographer::Authentication, :count).by(-1)
      end

      it 'redirects to the admin path' do
        destroy_action

        expect(response).to redirect_to(admin_authentications_path)
      end
    end
  end
end
