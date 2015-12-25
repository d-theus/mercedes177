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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151225065806) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "email",               default: "", null: false
    t.string   "login",               default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "admins", ["login"], name: "index_admins_on_login", unique: true, using: :btree

  create_table "cat_groups", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cat_groups_categories", id: false, force: true do |t|
    t.integer "cat_group_id"
    t.integer "category_id"
  end

  add_index "cat_groups_categories", ["cat_group_id"], name: "index_cat_groups_categories_on_cat_group_id", using: :btree
  add_index "cat_groups_categories", ["category_id"], name: "index_cat_groups_categories_on_category_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.string   "name"
    t.string   "serial"
    t.float    "price"
    t.integer  "count",             default: 0, null: false
    t.text     "description"
    t.text     "notice"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "body"
    t.integer  "featured_photo_id"
  end

  add_index "items", ["category_id"], name: "index_items_on_category_id", using: :btree

  create_table "orders", force: true do |t|
    t.string   "first_name",                        null: false
    t.string   "middle_name"
    t.string   "last_name",                         null: false
    t.string   "phone",                             null: false
    t.string   "email",                             null: false
    t.string   "status",          default: "Новый", null: false
    t.text     "address"
    t.string   "delivery_method",                   null: false
    t.text     "notice"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", force: true do |t|
    t.string   "image"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", force: true do |t|
    t.integer  "item_id"
    t.integer  "order_id"
    t.integer  "count",      default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "positions", ["item_id"], name: "index_positions_on_item_id", using: :btree
  add_index "positions", ["order_id"], name: "index_positions_on_order_id", using: :btree

end
