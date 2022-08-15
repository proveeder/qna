shared_examples_for 'API authenticable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      # get '/api/v1/questions', params: { access_token: '1234' }
      do_request(params: { access_token: '1234' })
      expect(response.status).to eq 401
    end
  end
end
