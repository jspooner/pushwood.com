namespace :wood do
  desc "Move street to address"
  task :add => :environment do
    Location.find_each do |loc|
      loc.lat = nil
      loc.lng = nil
      loc.save
    end
  end
  desc "L R Trim location name"
  task :trim => :environment do
    Location.find_each do |loc|
      loc.name = loc.name.to_s.lstrip.rstrip
      loc.description = loc.description.to_s.lstrip.rstrip
      puts loc.name
      loc.save
    end
  end
  desc "normalize United States"
  task 'normalize:usa' => :environment do
    Location
    .where("country LIKE ? or country LIKE ?", "US", "United States of America")
    .find_each do |loc|
      puts loc.country
      loc.update_attribute :country, "United States"
    end
  end
  desc "normalize states in the USA"
  task 'normalize:usa:states' => :environment do
    puts "Total USA: #{Location.where(:country => "United States").count}"
    Location.where(:country => "United States").find_each do |loc|
      puts "#{loc.state}, #{Carmen::state_name(loc.state.strip)}"
      if full_state_name = Carmen::state_name(loc.state.strip)
        loc.update_attribute :state, full_state_name
      end
    end
  end
end


namespace :geoplanet do
  DATA_PATH = File.join(Rails.root, 'data', 'geoplanet', 'geoplanet_data_7.6.0')
  namespace :import do
    task :all => [:places, :aliases, :adjacencies]
    task :places => :environment do
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE geoplanet_places")
      ActiveRecord::Base.connection.execute("ALTER TABLE geoplanet_places DISABLE KEYS")
      ActiveRecord::Base.connection.execute("LOAD DATA LOCAL INFILE '#{DATA_PATH}/geoplanet_places_7.6.0.tsv' REPLACE INTO TABLE geoplanet_places FIELDS TERMINATED BY '\\t' OPTIONALLY ENCLOSED BY '\"' IGNORE 1 LINES (woeid, country_code, name, language, place_type, parent_woeid);")
      ActiveRecord::Base.connection.execute("ALTER TABLE geoplanet_places ENABLE KEYS")
    end

    task :aliases => :environment do      
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE geoplanet_aliases")      
      ActiveRecord::Base.connection.execute("ALTER TABLE geoplanet_aliases DISABLE KEYS")      
      ActiveRecord::Base.connection.execute("LOAD DATA LOCAL INFILE '#{DATA_PATH}/geoplanet_aliases_7.6.0.tsv' REPLACE INTO TABLE geoplanet_aliases FIELDS TERMINATED BY '\\t' OPTIONALLY ENCLOSED BY '\"' IGNORE 1 LINES (woeid, name, name_type, language_code);")
      ActiveRecord::Base.connection.execute("ALTER TABLE geoplanet_aliases ENABLE KEYS")
    end

    task :adjacencies => :environment do
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE geoplanet_adjacencies")
      ActiveRecord::Base.connection.execute("ALTER TABLE geoplanet_adjacencies DISABLE KEYS")
      ActiveRecord::Base.connection.execute("LOAD DATA LOCAL INFILE '#{DATA_PATH}/geoplanet_adjacencies_7.6.0.tsv' REPLACE INTO TABLE geoplanet_adjacencies FIELDS TERMINATED BY '\\t' OPTIONALLY ENCLOSED BY '\"' IGNORE 1 LINES (woeid, iso_code, neighbour_woeid, neighbour_iso_code);")
      ActiveRecord::Base.connection.execute("ALTER TABLE geoplanet_adjacencies ENABLE KEYS")
    end
  end
end
