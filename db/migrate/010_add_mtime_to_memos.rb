class AddMtimeToMemos < ActiveRecord::Migration
  def self.up
    add_column :memos, :mtime, :datetime
  end

  def self.down
    delete_column :memos, :mtime
  end
end
