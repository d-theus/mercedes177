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

before 'deploy:starting', 'server:stop'
after 'deploy:finished', 'server:start'
