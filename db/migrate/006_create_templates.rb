class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.column :name, :string
      t.column :color, :string
      t.column :content, :text
    end
  end

  def self.down
    drop_table :templates
  end
end
