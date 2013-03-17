# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130317032452) do

  create_table "comments", :force => true do |t|
    t.string   "comment_text",    :null => false
    t.string   "quote_id"
    t.boolean  "email_sent_flag"
    t.string   "commenter_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "quote_images", :id => false, :force => true do |t|
    t.string   "id"
    t.string   "quote_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_name"
  end

  create_table "quote_witness_users", :force => true do |t|
    t.string   "quote_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "witness_quote_id"
  end

  create_table "quotes", :id => false, :force => true do |t|
    t.string   "id"
    t.string   "quote_text"
    t.datetime "quote_time"
    t.string   "speaker_user_id"
    t.string   "quotifier_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.string   "coordinate"
    t.datetime "messages_send_scheduled_time"
    t.boolean  "messages_sent_flag"
    t.boolean  "error_flag"
    t.string   "error_string"
    t.string   "quotifier_quote_id"
    t.string   "speaker_quote_id"
    t.boolean  "deleted"
    t.string   "mode"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "contact_method"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
