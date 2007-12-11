class AddIndexAndLimitToMemosAndBbsMemos < ActiveRecord::Migration
  def self.up
    add_index :memos, :content, "fulltext"
    add_index :bbs_memos, :content, "fulltext"
  end

  def self.down
    remove_index :memos, :content
    remove_index :bbs_memos, :content
  end
end
