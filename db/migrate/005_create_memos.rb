class CreateMemos < ActiveRecord::Migration
  def self.up
    create_table :memos do |t|
      t.column :person_id, :integer
      t.column :template_id, :integer
      t.column :color, :string
      t.column :content, :text
      t.column :ctime, :datetime
      t.column :checked, :boolean
    end
  end

  def self.down
    drop_table :memos
  end
end
