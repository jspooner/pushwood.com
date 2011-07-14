
namespace :import do
  namespace :cd do
    
    desc "Import new pages from CD"
    task :new => :environment do
      (15241...23000).each do |x|
        puts x
        CdPage.parse_remote(x)
      end      
    end
    
    desc "Save pages to location table"
    task :fixstreet => :environment do
      Location.find_each do |loc|
        a = loc.street.split(",") || []
        if a.length == 2
          loc.street = a.first
          loc.save
        end
      end
    end
    
    # todo Add URL and Email
    desc "Save pages to location table"
    task :save => :environment do
      CdPage.find_each do |cd|
        
        street = cd.data[:street] || ""
        street.gsub!("Address:","")
        street.gsub!("<br","")
        
        if Location.where(:name => cd.data[:title]).exists?
          puts "\rWe have #{cd.id} #{cd.data[:title]}\r"
        else
          l = Location.create({
            :cd_page => cd,
            :name => cd.data[:title],
            :street => street,
            :state => cd.data[:state],
            :city => cd.data[:city],
            :description => cd.data[:description],
            :has_concrete => cd.data[:concrete],
            :is_free => cd.data[:free],
            :is_outdoors => cd.data[:outdoors],
            :phone => cd.data[:phone]
          })
         puts "\r"
         puts l.inspect
         puts "\r"                  
        end
        
        
      end
    end
    
  end
end