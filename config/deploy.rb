require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano_colors'

set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :repository, "git@github.com:maxd/convert-iphone-png.git"
set :scm, :git
set :deploy_via, :copy
set :copy_strategy, :export
set :copy_exclude, [ ".git" ]

role(:web) { "#{app_server}" }
role(:db, :primary => true) { "#{app_server}" }

set :user, "deployer"
set :use_sudo, false

set(:deploy_to) { "/home/deployer/apps/#{rails_env}/#{application}" }

set :rvm_ruby_string, "1.9.3"
set :rvm_type, :system

namespace :deploy do
  task :start do ; end

  task :stop do ; end

  task :restart, :roles => :web, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :configure_symlinks, :roles => :web do
    run "ln -nfs #{shared_path}/config/database.yml #{current_release}/config/database.yml"
  end
end

#
# Hooks
#
after "deploy:update_code" do
  deploy.configure_symlinks
end