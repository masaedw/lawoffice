class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.column :name, :string
      t.column :phone, :string
      t.column :memo, :string
      t.column :posx, :integer
      t.column :posy, :integer
      t.column :location_id, :integer
    end
  end

  def self.down
    drop_table :people
  end
end
