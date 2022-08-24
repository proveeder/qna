# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/sidekiq'
require 'thinking_sphinx/capistrano'
require 'capistrano3/unicorn'

install_plugin Capistrano::Sidekiq
install_plugin Capistrano::Sidekiq::Systemd

require 'net/ssh/authentication/ed25519'
require 'whenever/capistrano'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
