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

ActiveRecord::Schema.define(:version => 20110517141820) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cd_pages", :force => true do |t|
    t.string   "url"
    t.string   "guid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "data"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "bounding_box"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "street"
    t.string   "postal"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.text     "description"
    t.string   "lat"
    t.string   "lng"
    t.string   "phone"
    t.integer  "has_lights",        :limit => 1, :default => 0
    t.integer  "is_free",           :limit => 1, :default => 0
    t.integer  "is_outdoors",       :limit => 1, :default => 0
    t.integer  "are_pads_required", :limit => 1, :default => 0
    t.integer  "has_concrete",      :limit => 1, :default => 0
    t.integer  "has_wood",          :limit => 1, :default => 0
    t.integer  "cd_page_id"
  end

  create_table "tricks", :force => true do |t|
    t.integer  "user_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "lat"
    t.string   "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                              :default => "", :null => false
    t.string   "encrypted_password",                 :default => ""
    t.string   "password_salt",                      :default => ""
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "failed_attempts",                    :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "invitation_token",     :limit => 20
    t.datetime "invitation_sent_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "image_a_id"
    t.integer  "image_b_id"
    t.integer  "user_id"
    t.integer  "winner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
