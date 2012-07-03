namespace :rubber do
  namespace :util do
    namespace :ey do
  
      rubber.allow_optional_tasks(self)

      desc <<-DESC
        push local mysql files
      DESC
      task :push_local_mysql do
        upload "/Users/jonathanspooner/Downloads/pushwoodcom.2012-07-01T01-10-04.gz", "/home/ubuntu/pushwoodcom.2012-07-01T01-10-04.gz"
        run "gunzip /home/ubuntu/pushwoodcom.2012-07-01T01-10-04.gz"
        rsudo "mysql -h 127.0.0.1 -u pushwood -p pushwood_production < ./pushwoodcom.2012-07-01T01-10-04"
  
        upload "/Users/jonathanspooner/Downloads/redis_state.rdb", "/home/ubuntu/redis_state.rdb"
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
        upload "engineyard/system/uploads/", "/mnt/pushwood-production/shared/system/uploads/"
      end
      
    end
  end
end