# # Load Redis connection
# rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
# rails_env = ENV['RAILS_ENV'] || 'development'
# 
# yaml_config = YAML.load_file(rails_root + '/config/redis.yml')
# redis_config = HashWithIndifferentAccess.new(yaml_config)
# $redis = Redis.new(redis_config[rails_env])
$redis = Redis.new(:host => 'localhost', :port => 6379)

require 'redis/objects'
Redis::Objects.redis = $redis