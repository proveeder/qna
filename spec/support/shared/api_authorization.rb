shared_examples_for 'API authenticable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(params: { access_token: '1234' })
      expect(response.status).to eq 401
    end
  end

  def do_request(params = {})
    get '/api/v1/questions', params
  end
end
