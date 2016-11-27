class Admin::Location < Location
  def self.markers_have_been_verified verified_ids
    where("id IN (?)",verified_ids).update_all(:marker_verified => true)
  end
  def self.markers_have_been_invalidated invalid_ids
    where("id IN (?)",invalid_ids).update_all(:marker_verified => false)
  end
end