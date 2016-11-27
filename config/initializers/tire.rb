# Tire.configure { logger 'log/elasticsearch.log', :level => 'debug' }

# Set the prefix for models sitewide
# Define the name based on the environment
# We wouldn't like to erase dev data during test runs!

begin
  Tire::Model::Search.index_prefix "#{Rails.env}-#{Rails.application.class.to_s.downcase}"

  [Location].each do |klass|
    klass.create_search_index unless klass.index.exists?
  end  
rescue  => e
  
end

