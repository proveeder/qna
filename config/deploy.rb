# config valid for current version and patch releases of Capistrano
lock '~> 3.17.1'

set :application, 'qna'
set :repo_url, 'git@github.com:Alex171823/qna.git'
set :branch, 'main' # branch names was changed in github ¯\_( )_/¯

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/qna'
set :deploy_user, 'deployer'

# Default value for :format is :airbrussh.
set :format, :airbrussh

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/master.key', '.env'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/webpacker', 'public/system',
       'vendor', 'storage',  'public/uploads'

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

before "deploy:assets:precompile", "deploy:yarn_install"
namespace :deploy do
  desc "Run rake yarn install"
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional")
      end
    end
  end
end

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Restart mechanism here
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc "Run rake yarn install"
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional")
      end
    end
  end

  after :publishing, :restart
end
