namespace :rubber do
  
  # https://newrelic.com/docs/server/new-relic-for-server-monitoring#installation
  namespace :newrelic do

    rubber.allow_optional_tasks(self)
    
    task :install do
      rsudo 'echo "deb http://apt.newrelic.com/debian/ newrelic non-free" >> /etc/apt/sources.list.d/newrelic.list'
      rsudo "wget -O- http://download.newrelic.com/548C16BF.gpg | sudo apt-key add -"
      rsudo "apt-get update"
      rsudo "apt-get install newrelic-sysmond"
      rsudo "nrsysmond-config --set license_key=4ca985f50d2033c286a1be4b4de72dfce492c809"
    end
    
    # # after "rubber:install_packages", "rubber:torquebox:custom_install"
    # # 
    # task :custom_install, :roles => [:web, :app] do
    #   rubber.sudo_script 'install_newrelic', <<-ENDSCRIPT
    #   wget -qN http://download.newrelic.com/server_monitor/release/newrelic-sysmond-1.1.2.124-linux.tar.gz
    #   tar xzvf newrelic-sysmond-1.1.2.124-linux.tar.gz
    #   cd newrelic-sysmond-1.1.2.124-linux
    #   
    #   # [32-bit:]
    #   # cp daemon/nrsysmond.x86 /usr/local/bin/nrsysmond
    #   # cp scripts/nrsysmond-config /usr/local/bin
    # 
    #   # [64-bit:]
    #   cp daemon/nrsysmond.x64 /usr/local/bin/nrsysmond
    #   cp scripts/nrsysmond-config /usr/local/bin
    #   
    #   mkdir -p /etc/newrelic /var/log/newrelic
    #   chmod 1777 /etc/newrelic /var/log/newrelic
    #   
    #   cp nrsysmond.cfg /etc/newrelic/nrsysmond.cfg
    #   
    #   nrsysmond-config --set license_key=4ca985f50d2033c286a1be4b4de72dfce492c809
    #   
    #   ENDSCRIPT
    # end
    # 
    # after "rubber:install_packages", "rubber:torquebox:install_mod_cluster"
    # 
    # task :restart, :roles => :torquebox do
    #   stop
    #   start
    # end
    # 
    # task :stop, :roles => :torquebox do
    #   rsudo "service torquebox stop || true"
    # end
    # 
    task :start, :roles => [:web, :app] do
      rsudo "/etc/init.d/newrelic-sysmond start"
    end
    # 
    # after "deploy:restart", "rubber:torquebox:reload"
    # 
    # desc "Reloads the apache web server"
    # task :reload, :roles => :torquebox do
    #   serial_reload
    # end

  end
end