namespace :rubber do
  namespace :util do
    namespace :ey do
  
      rubber.allow_optional_tasks(self)

      desc <<-DESC
        push local mysql files
      DESC
      task :push_local_mysql do
        sql_filename = "pushwoodcom.2012-07-15T01-10-03"
        upload "/Users/jonathanspooner/Downloads/#{sql_filename}.gz", "/home/ubuntu/#{sql_filename}.gz"
        run "gunzip /home/ubuntu/#{sql_filename}.gz"
        env = rubber_cfg.environment.bind("mysql_master", "web01")
        rsudo "mysql --host=web01.pushwood.com --user=pushwood --password=#{env.db_pass} pushwood_production < /home/ubuntu/#{sql_filename}"
      end

      desc <<-DESC
        push local redis files
      DESC
      task :pull_redis do
        `rm db/redis_state.rdb`
        system("scp -r deploy@ec2-107-20-242-3.compute-1.amazonaws.com:/db/redis/redis_state.rdb db/redis_state.rdb")
      end

      desc <<-DESC
        push local redis files
      DESC
      task :push_local_redis do
        upload "db/redis_state.rdb", "/mnt/redis/redis_state.rdb"
      end
      
      desc <<-DESC
        push local images
      DESC
      task :push_local_images do
        system("tar cvzf ./public/system.tar.gz ./public/system")
        upload "./public/system.tar.gz", "#{shared_path}/system/uploads.tar.gz"
        rsudo "tar xvzf #{shared_path}/system/uploads.tar.gz #{shared_path}/system/uploads"
        # rsudo "rm tarbar.tar.gz"
      end
      
      task :pulldown_images do
        system("scp -r deploy@ec2-107-20-242-3.compute-1.amazonaws.com:/data/pushwoodcom/shared/system/ ./public/")
      end
      
    end
  end
end