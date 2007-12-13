class AddCheckedToBbsMemos < ActiveRecord::Migration
  def self.up
    add_column :bbs_memos, :checked, :boolean
  end

  def self.down
    remove_column :bbs_memos, :checked
  end
end
