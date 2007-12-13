# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 14) do

  create_table "bbs_memos", :force => true do |t|
    t.integer  "template_id"
    t.text     "content"
    t.datetime "created_at"
    t.text     "color"
    t.boolean  "checked"
    t.datetime "updated_at"
  end

  add_index "bbs_memos", ["content"], :name => "fulltext_index"
  add_index "bbs_memos", ["content"], :name => "index_bbs_memos_on_content"

  create_table "interested_people", :force => true do |t|
    t.integer "person_id"
    t.integer "bbs_memo_id"
    t.boolean "checked"
  end

  create_table "locations", :force => true do |t|
    t.string  "name"
    t.string  "color"
    t.boolean "listup"
    t.integer "position"
  end

  create_table "memos", :force => true do |t|
    t.integer  "person_id"
    t.integer  "template_id"
    t.string   "color"
    t.text     "content"
    t.datetime "ctime"
    t.boolean  "checked"
    t.datetime "mtime"
  end

  add_index "memos", ["content"], :name => "fulltext_index"
  add_index "memos", ["content"], :name => "index_memos_on_content"

  create_table "meteors", :force => true do |t|
    t.text     "javascript"
    t.integer  "limit"
    t.datetime "created_at"
  end

  create_table "people", :force => true do |t|
    t.string  "name"
    t.string  "phone"
    t.string  "message"
    t.integer "posx"
    t.integer "posy"
    t.integer "location_id"
  end

  create_table "schedules", :force => true do |t|
    t.string "body"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "templates", :force => true do |t|
    t.string "name"
    t.string "color"
    t.text   "content"
  end

end
