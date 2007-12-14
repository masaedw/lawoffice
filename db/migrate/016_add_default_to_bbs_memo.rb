class AddDefaultToBbsMemo < ActiveRecord::Migration
  def self.up
    change_column :bbs_memos, :checked, :boolean, :default => false
  end

  def self.down
  end
end
