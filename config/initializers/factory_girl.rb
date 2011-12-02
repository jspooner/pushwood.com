module FactoryGirl
  # Adapted from:
  # http://stackoverflow.com/questions/2015473/using-factory-girl-in-rails-with-associations-that-have-unique-constraints-getti
  def self.saved_single_instances
    @saved_single_instances ||= {}
  end
  
  def self.single_instance(factory_key)
    begin
      saved_single_instances[factory_key].reload
    rescue NoMethodError, ActiveRecord::RecordNotFound
      #was never created (is nil) or was cleared from db
      saved_single_instances[factory_key] = FactoryGirl.create(factory_key)  #recreate
    end
  end
end
