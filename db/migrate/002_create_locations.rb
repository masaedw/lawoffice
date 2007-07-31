class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.column :name, :string
      t.column :color, :string
      t.column :listup, :boolean
      t.column :position, :integer
    end
  end

  def self.down
    drop_table :locations
  end
end
