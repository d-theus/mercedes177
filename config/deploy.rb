# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'mercedes177'
set :repo_url, 'https://github.com/d-theus/mercedes177.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

set :linked_dirs, fetch(:linked_dirs, [])
.push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# rbenv
set :rbenv_ruby, '2.2.0'

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  namespace :backends do
    task :restart do
      on roles(:web), in: :groups, limit: 3, wait: 10 do
        sudo 'systemctl', 'restart', 'thin@0'
        sudo 'systemctl', 'restart', 'thin@1'
        sudo 'systemctl', 'restart', 'thin@2'
      end
    end

    task :start do
      on roles(:web), in: :groups, limit: 3, wait: 10 do
        sudo 'systemctl', 'start', 'thin@0'
        sudo 'systemctl', 'start', 'thin@1'
        sudo 'systemctl', 'start', 'thin@2'
      end
    end

    task :stop do
      on roles(:web), in: :groups, limit: 3, wait: 10 do
        sudo 'systemctl', 'stop', 'thin@0'
        sudo 'systemctl', 'stop', 'thin@1'
        sudo 'systemctl', 'stop', 'thin@2'
      end
    end
  end
end

after 'deploy:finishing', 'deploy:restart'
