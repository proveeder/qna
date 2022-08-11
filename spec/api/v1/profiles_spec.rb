require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me'
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: { access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create :user }
      let(:token) { create(:access_token) }

      before { get '/api/v1/profiles/me', headers: { 'Authorization': "Bearer #{token.token}" } }

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end
    end
  end
end
