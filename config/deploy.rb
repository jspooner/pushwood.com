require 'bundler/capistrano'

default_environment['PATH']='/home/pushwood/.gems/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games'
default_environment['GEM_PATH']='/home/pushwood/.gems/:/usr/lib/ruby/gems/1.8'


set :user, 'pushwood'  # Your dreamhost account's username
set :domain, 'pushwood.com'  # Dreamhost servername where your account is located 
set :application, 'pushwood.com'  # Your app's location (domain or sub-domain name as setup in panel)
set :applicationdir, "/home/#{user}/#{application}"  # The standard Dreamhost setup

# version control config
set :scm_username, "deploy"
set :scm_password, "g0Skat3!"
set :repository, "http://labs.jonathanspooner.com/woodsvn/web/trunk"

# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true

# deploy config
set :deploy_to, applicationdir
set :deploy_via, :export

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
#ssh_options[:keys] = %w(/Path/To/id_rsa)            # If you are using ssh_keys
set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false



server domain, :app, :web
role :db, domain, :primary => true


before "deploy:gems", "deploy:symlink"



