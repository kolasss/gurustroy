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

ActiveRecord::Schema.define(version: 20160105093441) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.text     "description"
    t.float    "quantity"
    t.integer  "unit_id"
    t.integer  "price"
    t.integer  "status",      default: 0, null: false
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "orders", ["category_id"], name: "index_orders_on_category_id", using: :btree
  add_index "orders", ["unit_id"], name: "index_orders_on_unit_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.string   "file"
    t.integer  "post_id"
    t.string   "post_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "photos", ["post_type", "post_id"], name: "index_photos_on_post_type_and_post_id", using: :btree

  create_table "proposals", force: :cascade do |t|
    t.integer  "order_id"
    t.text     "description"
    t.integer  "price"
    t.integer  "status",      default: 0, null: false
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "proposals", ["order_id"], name: "index_proposals_on_order_id", using: :btree
  add_index "proposals", ["user_id"], name: "index_proposals_on_user_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",        null: false
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "tags", ["category_id"], name: "index_tags_on_category_id", using: :btree

  create_table "units", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "phone"
    t.string   "name"
    t.string   "company"
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "orders", "categories"
  add_foreign_key "orders", "units"
  add_foreign_key "orders", "users"
  add_foreign_key "proposals", "orders"
  add_foreign_key "proposals", "users"
  add_foreign_key "tags", "categories"
end
