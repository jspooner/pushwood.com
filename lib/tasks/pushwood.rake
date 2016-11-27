

namespace :pushwood do
  desc "fix state abbreviations"
  task :state_abbreviations => :environment do
    Location.where(:country => "United States").find_each do |location|
      if state_name = Carmen.state_name(location.state)
        location.update_attribute :state, state_name
      end
    end
  end
  
  desc "Download google static maps"
  task :download_googlestatic_maps => :environment do
    Location.find_each { |l| GoogleMapWorker.perform_async l.id }
  end
end