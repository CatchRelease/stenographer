# frozen_string_literal: true

describe Stenographer::AuthenticationsController, type: :controller do
  routes { Stenographer::Engine.routes }

  # Unclear why this doesn't match the route
  # describe '#create' do
  #   let(:auth_hash) { Faker::Omniauth.google }
  #
  #   def create_action(opts = {})
  #     request.env['omniauth.auth'] = auth_hash
  #
  #     get :create, params: {}.merge(opts)
  #   end
  #
  #   describe 'individual behaviors' do
  #     it 'creates an authentication' do
  #       expect {
  #         create_action
  #       }.to change(Stenographer::Authentication, :count).by(1)
  #     end
  #
  #     describe 'assignments' do
  #       before :each do
  #         create_action
  #       end
  #
  #       it 'assigns @authentication_count' do
  #         expect(Stenographer::Authentication.last.uid).to eq('a')
  #       end
  #
  #       it 'renders the index page' do
  #         expect(Stenographer::Authentication.last.provider).to eq('a')
  #       end
  #     end
  #   end
  # end
end
