$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'

require 'bundler/capistrano'
require 'railsless-deploy'

set :application, "adhearsion-website"

default_run_options[:pty] = true
set :repository, "https://github.com/adhearsion/adhearsion-website.git"
set :scm, :git
set :deploy_via, :export # :remote_cache
set :use_sudo, false

set :deploy_to, "/home/adhearsion/adhearsion-website"
set :user, "deploy"

role :app, "adhearsion.com"

set :rvm_ruby_string, "ruby-1.9.2"
set :rvm_type, :user

set(:current_branch) { `git branch`.match(/\* (\S+)\s/m)[1] || raise("Couldn't determine current branch") }
set :branch, defer { current_branch }

namespace :deploy do
  desc "A macro-task that updates the code and fixes the symlink."
  task :default do
    transaction do
      update_code
      symlink
      cleanup
      restart
    end
  end

  task :update_code, :except => { :no_release => true } do
    on_rollback { run "rm -rf #{release_path}; true" }
    strategy.deploy!
  end

  desc "Restart app"
  task :restart, :roles => :app do
    run "touch #{release_path}/tmp/restart.txt"
  end
end
