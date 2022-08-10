module OmniauthMacros
  def mock_auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:twitter2] = OmniAuth::AuthHash.new({
                                                                    'provider' => 'twitter2',
                                                                    'uid' => '123456',
                                                                    'info' => {
                                                                      'name' => 'mockuser',
                                                                      'email' => nil
                                                                    },
                                                                    'credentials' => {
                                                                      'token' => 'mock_token',
                                                                      'secret' => 'mock_secret'
                                                                    }
                                                                  })

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                  'provider' => 'github',
                                                                  'uid' => '123456',
                                                                  'info' => {
                                                                    'name' => 'mockuser',
                                                                    'email' => 'mockuser@email.org'
                                                                  },
                                                                  'credentials' => {
                                                                    'token' => 'mock_token',
                                                                    'secret' => 'mock_secret'
                                                                  }
                                                                })
  end
end
