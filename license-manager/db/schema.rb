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

ActiveRecord::Schema.define(:version => 20121220021720) do

  create_table "license_productships", :force => true do |t|
    t.integer  "license_id", :null => false
    t.integer  "product_id", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "license_productships", ["license_id", "product_id"], :name => "index_license_productships_on_license_id_and_product_id", :unique => true

  create_table "licenses", :force => true do |t|
    t.string   "custom_name"
    t.string   "applicant"
    t.text     "publish_reason"
    t.text     "publish_content"
    t.date     "expires_date"
    t.string   "version"
    t.string   "local_check_type"
    t.string   "local_check"
    t.integer  "user_number"
    t.text     "memo"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "gjb_level"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "is_must"
  end

  create_table "system_configs", :force => true do |t|
    t.string   "site_name"
    t.string   "license_path"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login_name",                         :null => false
    t.string   "password",                           :null => false
    t.string   "name",                               :null => false
    t.string   "email"
    t.datetime "last_login_time"
    t.string   "last_login_ip"
    t.boolean  "is_lock",         :default => false
    t.boolean  "is_admin",        :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "key"
  end

end
