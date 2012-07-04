namespace :rubber do
  namespace :util do
    namespace :ey do
  
      rubber.allow_optional_tasks(self)

      desc <<-DESC
        push local mysql files
      DESC
      task :push_local_mysql do
        sql_filename = "pushwoodcom.2012-07-03T01-10-03"
        # upload "/Users/jonathanspooner/Downloads/#{sql_filename}.gz", "/home/ubuntu/#{sql_filename}.gz"
        # run "gunzip /home/ubuntu/#{sql_filename}.gz"
        rsudo "mysql -h 127.0.0.1 -u pushwood -p pushwood_production < /home/ubuntu/#{sql_filename}"
      end

      desc <<-DESC
        push local redis files
      DESC
      task :push_local_redis do
        upload "/Users/jonathanspooner/Downloads/redis_state.rdb", "/mnt/redis/redis_state.rdb"
      end

      desc <<-DESC
        push local images
      DESC
      task :push_local_images do
        # tar cvzf uploads.tar.gz uploads
        # upload "engineyard/system/uploads.tar.gz", "/mnt/pushwood-production/shared/system/uploads.tar.gz"
        rsudo "tar xvzf #{shared_path}/system/uploads.tar.gz #{shared_path}/system/uploads"
        # rsudo "rm tarbar.tar.gz"
      end
      
    end
  end
end