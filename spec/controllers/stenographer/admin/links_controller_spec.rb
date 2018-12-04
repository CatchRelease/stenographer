# frozen_string_literal: true

describe Stenographer::Admin::LinksController, type: :controller do
  routes { Stenographer::Engine.routes }

  let!(:first_link) { create(:link, created_at: 2.weeks.ago) }
  let!(:newer_link) { create(:link, created_at: 1.week.ago) }

  describe '#new' do
    def new_action(opts = {})
      get :new, params: { }.merge(opts)
    end

    describe 'individual behaviors' do
      before do
        new_action
      end

      it 'assigns @link' do
        expect(assigns(:link)).not_to be_nil
      end

      it 'renders the new page' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#create' do
    def create_action(opts = {})
      post :create, params: { link: { url: 'https://catchandrelease.com', description: 'Clearances and Licensing' } }.merge(opts)
    end

    describe 'individual behaviors' do
      describe 'success' do
        it 'creates the record' do
          expect do
            create_action
          end.to change(Stenographer::Link, :count).by(1)
        end

        it 'redirects to the admin path' do
          create_action

          expect(response).to redirect_to(admin_link_path(Stenographer::Link.last))
        end
      end

      describe 'failure' do
        it 'does not create the record' do
          expect do
            create_action(link: { url: nil })
          end.not_to change(Stenographer::Link, :count)
        end

        it 'redirects to the admin path' do
          create_action(link: { url: nil })

          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe '#index' do
    def index_action(opts = {})
      get :index, params: {}.merge(opts)
    end

    describe 'individual behaviors' do
      before do
        index_action
      end

      describe 'links' do
        it 'assigns @links' do
          expect(assigns(:links)).not_to be_nil
        end

        it 'includes all links' do
          expect(assigns(:links)).to include(first_link)
          expect(assigns(:links)).to include(newer_link)
        end
      end

      describe 'order' do
        it 'created at desc' do
          expect(assigns(:links)).to match_array([newer_link, first_link])
        end
      end
    end
  end

  describe '#show' do
    def show_action(opts = {})
      get :show, params: { id: first_link.id }.merge(opts)
    end

    describe 'individual behaviors' do
      before do
        show_action
      end

      it 'assigns @change' do
        expect(assigns(:link)).to eq(first_link)
      end

      it 'renders the show page' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe '#edit' do
    def edit_action(opts = {})
      get :edit, params: { id: first_link.id }.merge(opts)
    end

    describe 'individual behaviors' do
      before do
        edit_action
      end

      it 'assigns @link' do
        expect(assigns(:link)).to eq(first_link)
      end

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe '#update' do
    def update_action(opts = {})
      patch :update, params: { id: first_link.id, link: { description: 'GitHub' } }.merge(opts)
    end

    describe 'individual behaviors' do
      before do
        update_action
      end

      it 'updates the record' do
        expect(first_link.reload.description).to eq('GitHub')
      end

      it 'redirects to the admin change path' do
        expect(response).to redirect_to(admin_link_path(first_link))
      end
    end
  end

  describe '#destroy' do
    def destroy_action(opts = {})
      delete :destroy, params: { id: first_link.id }.merge(opts)
    end

    describe 'individual behaviors' do
      it 'destroys the record' do
        expect do
          destroy_action
        end.to change(Stenographer::Link, :count).by(-1)
      end

      it 'redirects to the admin path' do
        destroy_action

        expect(response).to redirect_to(admin_links_path)
      end
    end
  end
end
