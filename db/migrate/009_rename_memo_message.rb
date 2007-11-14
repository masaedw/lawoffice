class RenameMemoMessage < ActiveRecord::Migration
  def self.up
    rename_column :people, :memo, :message
  end

  def self.down
    rename_column :people, :message, :memo
  end
end
