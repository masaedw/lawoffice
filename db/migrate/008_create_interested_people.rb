class CreateInterestedPeople < ActiveRecord::Migration
  def self.up
    create_table :interested_people do |t|
      t.column :person_id, :integer
      t.column :bbs_memo_id, :integer
      t.column :checked, :boolean
    end
  end

  def self.down
    drop_table :interested_people
  end
end
