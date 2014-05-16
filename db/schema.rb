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

ActiveRecord::Schema.define(:version => 20130701143113) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "code"
    t.integer  "user_id"
  end

  create_table "categories_users", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "user_id"
  end

  add_index "categories_users", ["category_id", "user_id"], :name => "index_categories_users_on_category_id_and_user_id"

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.string   "tin"
    t.string   "phone"
    t.string   "address"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "email"
    t.string   "city"
  end

  create_table "deliverables", :force => true do |t|
    t.integer  "product_id"
    t.integer  "micropost_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "quantity"
    t.decimal  "del_price",    :precision => 8, :scale => 2
    t.decimal  "unit_price",   :precision => 8, :scale => 2
  end

  create_table "infos", :force => true do |t|
    t.string   "sur_name"
    t.text     "gen_info"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.decimal  "tax",          :precision => 8, :scale => 2
    t.string   "state"
    t.decimal  "sur_tax",      :precision => 8, :scale => 2
    t.integer  "tax_id"
    t.integer  "micropost_id"
  end

  create_table "microposts", :force => true do |t|
    t.text     "content",        :limit => 255
    t.integer  "user_id"
    t.datetime "created_at",                                                                     :null => false
    t.datetime "updated_at",                                                                     :null => false
    t.integer  "customer_id"
    t.integer  "category_id"
    t.boolean  "unedit",                                                      :default => false
    t.decimal  "tax",                           :precision => 8, :scale => 2
    t.string   "state"
    t.string   "invoice_number"
    t.decimal  "sur_tax",                       :precision => 8, :scale => 2
    t.string   "sur_name"
    t.text     "gen_info",       :limit => 255
    t.date     "bill_date"
    t.string   "esugam"
    t.integer  "info_id"
  end

  add_index "microposts", ["user_id", "created_at"], :name => "index_microposts_on_user_id_and_created_at"

  create_table "products", :force => true do |t|
    t.string   "description"
    t.string   "name"
    t.integer  "minimum_units"
    t.integer  "user_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "unit",          :limit => 8
    t.string   "code"
  end

  create_table "taxes", :force => true do |t|
    t.string  "state"
    t.decimal "rate"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
    t.string   "esugam_id"
    t.string   "esugam_pwd"
    t.string   "tin"
    t.string   "address"
    t.string   "phone"
    t.string   "bank_acc_no"
    t.string   "ifscode"
    t.string   "city"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
