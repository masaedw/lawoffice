class AddDefaultToInterestedPeople < ActiveRecord::Migration
  def self.up
    change_column :interested_people, :checked, :boolean, :default => false
  end

  def self.down
  end
end
