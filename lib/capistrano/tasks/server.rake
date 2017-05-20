namespace :server do
  task :stop do
    on roles :app do
      execute '/home/web/.rbenv/bin/rbenv exec thin stop -C /etc/thin/config.yml; true'
      execute 'sudo /usr/bin/systemctl stop nginx'
    end
  end

  task :start do
    on roles :app do
      execute '/home/web/.rbenv/shims/thin start -C /etc/thin/config.yml'
      execute 'sudo /usr/bin/systemctl start nginx'
    end
  end

  task :restart do
    on roles :app do
      execute 'sudo /usr/bin/systemctl stop nginx'
      execute '/home/web/.rbenv/shims/thin stop -C /etc/thin/config.yml; true'
      execute '/home/web/.rbenv/shims/thin start -C /etc/thin/config.yml'
      execute 'sudo /usr/bin/systemctl start nginx'
    end
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

after 'deploy:finishing', 'backends:restart'
