# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :location do |f|
  f.name "Mission Valley YMCA Krause Family Skatepark"
  f.city "San Diego"
  f.street "Clairemont Dr"
  f.state "CA"
  f.postal "92117"
  f.country "United States"
  f.address "Clairemont Dr & Dakota Dr, San Diego, CA 92117"
  f.hours "10-8pm"
  f.lng "-117.19906366"
  f.lat "32.80500233"  
  f.phone "(619) 279-9254"
end