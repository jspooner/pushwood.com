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

ActiveRecord::Schema.define(:version => 20111201155510) do

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

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "geoplanet_adjacencies", :force => true do |t|
    t.integer "woeid",              :limit => 8
    t.string  "iso_code"
    t.integer "neighbour_woeid",    :limit => 8
    t.string  "neighbour_iso_code"
  end

  add_index "geoplanet_adjacencies", ["woeid"], :name => "index_geoplanet_adjacencies_on_woeid"

  create_table "geoplanet_aliases", :force => true do |t|
    t.integer "woeid",         :limit => 8
    t.string  "name"
    t.string  "name_type"
    t.string  "language_code"
  end

  add_index "geoplanet_aliases", ["woeid"], :name => "index_geoplanet_aliases_on_woeid"

  create_table "geoplanet_places", :force => true do |t|
    t.integer "woeid",        :limit => 8
    t.integer "parent_woeid", :limit => 8
    t.string  "country_code"
    t.string  "name"
    t.string  "language"
    t.string  "place_type"
    t.string  "ancestry"
  end

  add_index "geoplanet_places", ["ancestry"], :name => "index_geoplanet_places_on_ancestry"
  add_index "geoplanet_places", ["parent_woeid"], :name => "index_geoplanet_places_on_parent_woeid"
  add_index "geoplanet_places", ["woeid"], :name => "index_geoplanet_places_on_woeid", :unique => true

  create_table "images", :force => true do |t|
    t.integer  "location_id"
    t.string   "img_file_name"
    t.string   "img_content_type"
    t.string   "img_file_size"
    t.datetime "img_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.decimal  "lat",                         :precision => 15, :scale => 8, :default => 0.0
    t.decimal  "lng",                         :precision => 15, :scale => 8, :default => 0.0
    t.string   "phone"
    t.integer  "has_lights",     :limit => 1,                                :default => 0
    t.integer  "is_free",        :limit => 1,                                :default => 0
    t.integer  "is_outdoors",    :limit => 1,                                :default => 0
    t.integer  "pads_required",  :limit => 1,                                :default => 0
    t.integer  "has_concrete",   :limit => 1,                                :default => 0
    t.integer  "has_wood",       :limit => 1,                                :default => 0
    t.integer  "cd_page_id"
    t.string   "hours",                                                      :default => ""
    t.text     "address"
    t.integer  "images_count"
    t.decimal  "rating_average",              :precision => 6,  :scale => 2, :default => 0.0
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.string   "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_histories_on_item_and_table_and_month_and_year"

  create_table "rates", :force => true do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "stars",         :null => false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id", "rateable_type"], :name => "index_rates_on_rateable_id_and_rateable_type"
  add_index "rates", ["rater_id"], :name => "index_rates_on_rater_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
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
    t.string   "authentication_token"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.integer  "versioned_id"
    t.string   "versioned_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "user_name"
    t.text     "modifications"
    t.integer  "number"
    t.integer  "reverted_from"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "versions", ["created_at"], :name => "index_versions_on_created_at"
  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["tag"], :name => "index_versions_on_tag"
  add_index "versions", ["user_id", "user_type"], :name => "index_versions_on_user_id_and_user_type"
  add_index "versions", ["user_name"], :name => "index_versions_on_user_name"
  add_index "versions", ["versioned_id", "versioned_type"], :name => "index_versions_on_versioned_id_and_versioned_type"

  create_table "votes", :force => true do |t|
    t.integer  "image_a_id"
    t.integer  "image_b_id"
    t.integer  "user_id"
    t.integer  "winner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
