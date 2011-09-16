class VersionAllLocations < ActiveRecord::Migration
  def up
    Location.find_each(&:touch)
  end

  def down
  end
end
