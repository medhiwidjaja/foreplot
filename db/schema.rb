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

ActiveRecord::Schema.define(version: 2020_06_23_032907) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alternatives", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "abbrev"
    t.integer "position"
    t.bigint "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_alternatives_on_article_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "likes"
    t.string "slug"
    t.boolean "private"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "criteria", force: :cascade do |t|
    t.string "title"
    t.string "abbrev"
    t.string "description"
    t.boolean "cost"
    t.boolean "active"
    t.integer "comparison_type"
    t.integer "eval_method"
    t.string "property_name"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "article_id"
    t.integer "parent_id"
    t.index ["article_id"], name: "index_criteria_on_article_id"
  end

  create_table "properties", force: :cascade do |t|
    t.bigint "article_id"
    t.bigint "alternative_id"
    t.string "name"
    t.decimal "value"
    t.string "unit"
    t.boolean "is_cost"
    t.boolean "is_common"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alternative_id"], name: "index_properties_on_alternative_id"
    t.index ["article_id"], name: "index_properties_on_article_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.string "bio"
    t.string "account"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "alternatives", "articles"
  add_foreign_key "articles", "users"
  add_foreign_key "criteria", "articles"
  add_foreign_key "properties", "alternatives"
  add_foreign_key "properties", "articles"
end
