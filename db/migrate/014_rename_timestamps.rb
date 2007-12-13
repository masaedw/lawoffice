class RenameTimestamps < ActiveRecord::Migration
  def self.up
    rename_column :bbs_memos, :ctime, :created_at
    add_column :bbs_memos, :updated_at, :datetime
  end

  def self.down
    rename_column :bbs_memos, :created_at, :ctime
    remove_column :bbs_memos, :updated_at, :datetime
  end
end
