class CreateNotepadContents < ActiveRecord::Migration
  def self.up
    create_table :notepad_contents do |t|
      t.column :body, :text
    end
  end

  def self.down
    drop_table :notepad_contents
  end
end
