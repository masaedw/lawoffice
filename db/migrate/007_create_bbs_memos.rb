class CreateBbsMemos < ActiveRecord::Migration
  def self.up
    create_table :bbs_memos, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.column :template_id, :integer
      t.column :content, :text
      t.column :ctime, :datetime
      t.column :color, :text
    end
  end

  def self.down
    drop_table :bbs_memos
  end
end
