require 'csv' 
desc "Save lat/lng to redis"
task "wood:inspect" => :environment do
  CSV.open("log/skateparkscom.csv", "wb") do |csv|
    $redis.keys("anemone:pages:http://skatepark.com/skateparks/*").each do |key|
      puts "#{key}"
      skatepark = Pushwood::Skateparkcom.new( $redis.hget(key, "body") )
      csv << [key, skatepark.full_address, $redis.hget(key, "lat"), $redis.hget(key, "lng")]
      # if skatepark.full_address
      #   $redis.hset(key, "lat", skatepark.lat)
      #   $redis.hset(key, "lng", skatepark.lng)
      # end
    end
  end
end

desc "Save lat/lng to redis"
task "wood:save_lat_lng" => :environment do
    $redis.keys("anemone:pages:http://skatepark.com/skateparks/*").each do |key|
      puts "#{key}"
      skatepark = Pushwood::Skateparkcom.new( $redis.hget(key, "body") )
      skatepark.geocode_it
      if skatepark.lat and skatepark.lng
        $redis.hset key, "lat", skatepark.lat
        $redis.hset key, "lng", skatepark.lng
      end
    end
end

task "wood:overlap" => :environment do
  match_list    = []
  original_list = []
  $redis.keys("anemone:pages:http://skatepark.com/skateparks/*").each do |key|      
    locations = Location.near([$redis.hget(key, "lat").to_i, $redis.hget(key, "lng").to_i], 0.5).all
    if !locations.empty?
      match_list << [key, locations.collect{|l| l.name}]
    else
      original_list << key
    end
  end
  
  puts "match_list = #{match_list.length}"
  puts match_list
  puts "original_list = #{original_list.length}"
end

task "wood:import_overlap" => :environment do
  puts "Total Locations: #{Location.count}"
  match_list    = []
  original_list = []
  new_list      = []
  $redis.keys("anemone:pages:http://skatepark.com/skateparks/*").each do |key|      
    locations = Location.near([$redis.hget(key, "lat").to_i, $redis.hget(key, "lng").to_i], 1.5).all
    if !locations.empty?
      match_list << [key, locations]
    else
      skatepark = Pushwood::Skateparkcom.new( $redis.hget(key, "body") )
      if $redis.hget(key, "lat").to_i and $redis.hget(key, "lng").to_i and !skatepark.title.blank?
        original_list << key
        new_list << Location.create!({
          :name        => skatepark.title,
          :address     => skatepark.full_address,
          :description => key,
          :lat => $redis.hget(key, "lat").to_i,
          :lng => $redis.hget(key, "lng").to_i
        })        
      end
    end
  end
  
  puts "match_list = #{match_list.length}"
  puts "original_list = #{original_list.length}"
  puts "new_list = #{new_list.count}"
  puts "new_list = #{new_list.collect {|l| l.id}.join(", ")}"
end
