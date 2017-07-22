# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'mercedes177.ru'
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

set :skip_compose_down, ENV['SKIP_COMPOSE_DOWN']

namespace :docker do
  namespace :compose do
    task :up do
      on roles :app do
        within current_path do
          execute 'docker-compose', 'up', '-d', '--remove-orphans'
        end
      end
    end

    task :down do
      on roles :app do
        if test("[ -d #{current_path} ]") and capture('docker ps -q').lines.any?
          within current_path do
            execute 'docker-compose', 'down'
          end
        end
      end
    end

    task :onboot do
      on roles :app do
        execute "echo '@reboot cd #{current_path} && while [[ -z  $(#{capture 'which pgrep'} docker) ]]; do sleep 2; done && #{capture 'which docker-compose'} up -d' | crontab -"
      end
    end


    task :sitemap do
      on roles :app do
        within current_path do
          sleep 2
          execute 'docker-compose', 'exec', 'app', 'bundle exec rake sitemap:refresh'
        end
      end
    end

    task :migrate do
      on roles :app do
        within current_path do
          sleep 2
          execute 'docker-compose', 'exec', 'app', 'bundle exec rake db:migrate'
        end
      end
    end
  end

  task :persistence do
    config = YAML.load(File.read File.expand_path('docker-compose.yml'))
    on roles :app do
      $stderr.puts config['volumes'].inspect
      config['volumes']
      .select { |_, val| val && val.key?('external') }
      .each do |_, val|
        name = val['external']['name']
        execute "docker volume ls | grep -q #{name} &>/dev/null; if [ $? -eq 1 ]; then docker volume create --name #{name}; fi"
      end
    end
  end
end

namespace :deploy do
  task :upload_secret do
    on roles :app do
      upload! '.rbenv-vars', current_path
    end
  end

  after :updated,   'docker:compose:down' unless fetch(:skip_compose_down, false)
  after :published, :upload_secret
  after :published, 'docker:persistence'
  after :published, 'docker:compose:up'
  after :finished,  'docker:compose:migrate'
  after :finished,  'docker:compose:sitemap'
  after :finished,  'docker:compose:onboot'
end
