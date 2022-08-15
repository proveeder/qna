require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like 'API authenticable'

    context 'authorized' do
      let(:me) { create :user }
      let(:token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', headers: { 'Authorization': "Bearer #{token.token}" }, as: :json }

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      %w[id email created_at updated_at admin].each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w[password encrypted_password].each do |attr|
        it "contains #{attr}" do
          expect(response.body).to_not have_json_path attr
        end
      end
    end

    def do_request(params = {})
      get '/api/v1/profiles/me', params
    end
  end
end
