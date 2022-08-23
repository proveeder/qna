role :app, %w[deployer@167.172.178.243]
role :web, %w[deployer@167.172.178.243]
role :db,  %w[deployer@167.172.178.243]

set :rails_env, :production
set :stage, :production

server '167.172.178.243', user: 'deployer', roles: %w[web app db], primary: true

set :ssh_options, {
  keys: %w[/home/alex/.ssh/id_rsa],
  forward_agent: true,
  auth_methods: %w[publickey password],
  port: 4321
}
