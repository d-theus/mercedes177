namespace :assets do
  task 'recompile' do
    on roles :app do
      with rails_env: :production do
        within current_path do
          rake 'tmp:clear'
          rake 'assets:clobber'
          rake 'assets:precompile'
        end
      end
    end
  end
end
