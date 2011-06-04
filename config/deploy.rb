# Production
# large
# ssh -i ~/.ssh/pushwood.pem ec2-user@ec2-50-16-185-209.compute-1.amazonaws.com
# scp -r -i ~/.ssh/pushwood.pem ec2-user@ec2-50-16-185-209.compute-1.amazonaws.com:webapps/pushwood/shared/system/images/ .

require 'bundler/capistrano'

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.2'        # Or whatever env you want it to run in.
set :rvm_type, :user

ssh_options[:keys] = ["#{ENV['HOME']}/.ssh/pushwood.pem"]
set :application, "pushwood"
set :domain, "ec2-50-16-185-209.compute-1.amazonaws.com"
set :user, "ec2-user"
set :use_sudo, true
set :scm_username, "deploy"
set :scm_password, "g0Skat3!"
set :repository, "http://labs.jonathanspooner.com/woodsvn/web/trunk"
set :deploy_to,   "/home/ec2-user/webapps/#{application}"

role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
  
  desc "create symlink for shared stuff"
  task :create_symlink, :roles => :app do 
    run "ln -fns #{deploy_to}/#{shared_dir}/system #{current_release}/public/system" 
  end


  # desc "installs Bundler if it is not already installed"
  # task :install_bundler, :roles => :app do
  #   sudo "sh -c 'if [ -z `which bundle` ]; then echo Installing Bundler; sudo gem install bundler; fi'"
  # end
  # 
  # desc "run 'bundle install' to install Bundler's packaged gems for the current deploy"
  # task :bundle_install, :roles => :app do
  #   run "cd #{release_path} && bundle install"
  # end
  
end

desc "tail production log files" 
task :tail_logs, :roles => :app do
  run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}" 
    break if stream == :err    
  end
end

desc "Get production system files"
task :get_prod, :roles => :app do
  download("/home/ec2-user/webapps/pushwood/shared/system/images", "public/system/down")
end

# before "deploy:bundle_install", "deploy:install_bundler"
# after "deploy:update_code", "deploy:bundle_install"


# after 'deploy:update_code', 'bundler:bundle_new_release'
