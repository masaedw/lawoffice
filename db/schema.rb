# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 6) do

  create_table "locations", :force => true do |t|
    t.column "name",     :string
    t.column "color",    :string
    t.column "listup",   :boolean
    t.column "position", :integer
  end

  create_table "memos", :force => true do |t|
    t.column "person_id",   :integer
    t.column "template_id", :integer
    t.column "color",       :string
    t.column "content",     :text
    t.column "ctime",       :datetime
    t.column "read",        :boolean
  end

  create_table "meteors", :force => true do |t|
    t.column "javascript", :text
    t.column "limit",      :integer
    t.column "created_at", :datetime
  end

  create_table "people", :force => true do |t|
    t.column "name",        :string
    t.column "phone",       :string
    t.column "memo",        :string
    t.column "posx",        :integer
    t.column "posy",        :integer
    t.column "location_id", :integer
  end

  create_table "sessions", :force => true do |t|
    t.column "session_id", :string
    t.column "data",       :text
    t.column "updated_at", :datetime
  end

  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"
  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

  create_table "templates", :force => true do |t|
    t.column "name",    :string
    t.column "color",   :string
    t.column "content", :text
  end

end
