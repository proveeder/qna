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

# before "deploy:update_code", "thinking_sphinx:stop"
# after "deploy:symlink", "symlink_sphinx_indexes"
# after "deploy:symlink", "thinking_sphinx:configure"
# after "deploy:symlink", "thinking_sphinx:start"

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Restart mechanism here
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end
