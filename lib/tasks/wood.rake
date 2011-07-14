
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

  desc "titleize location name"
  task :titleize => :environment do
    Location.find_each do |loc|
      puts loc.name = loc.name.to_s.titleize
      loc.save
    end
  end


end