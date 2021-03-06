# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_18_092725) do

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

  create_table "appraisals", force: :cascade do |t|
    t.bigint "criterion_id"
    t.bigint "member_id"
    t.boolean "is_valid"
    t.string "appraisal_method"
    t.boolean "is_complete"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rank_method"
    t.decimal "consistency_ratio"
    t.string "comparable_type"
    t.boolean "minimize"
    t.decimal "range_min"
    t.decimal "range_max"
    t.boolean "normalize"
    t.index ["criterion_id"], name: "index_appraisals_on_criterion_id"
    t.index ["member_id"], name: "index_appraisals_on_member_id"
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

  create_table "comparisons", force: :cascade do |t|
    t.integer "comparable_id"
    t.string "comparable_type"
    t.string "title"
    t.string "notes"
    t.decimal "score"
    t.decimal "score_n"
    t.string "comparison_method"
    t.decimal "value"
    t.string "unit"
    t.integer "rank"
    t.decimal "consistency"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "appraisal_id"
    t.integer "position"
    t.index ["appraisal_id"], name: "index_comparisons_on_appraisal_id"
    t.index ["comparable_type", "comparable_id"], name: "index_comparisons_on_comparable_type_and_comparable_id"
  end

  create_table "criteria", force: :cascade do |t|
    t.string "title"
    t.string "abbrev"
    t.string "description"
    t.boolean "cost"
    t.boolean "active"
    t.string "property_name"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "article_id"
    t.integer "parent_id"
    t.string "comparison_type"
    t.string "appraisal_method"
    t.index ["article_id"], name: "index_criteria_on_article_id"
  end

  create_table "follows", force: :cascade do |t|
    t.string "followable_type", null: false
    t.bigint "followable_id", null: false
    t.string "follower_type", null: false
    t.bigint "follower_id", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followable_id", "followable_type"], name: "fk_followables"
    t.index ["followable_type", "followable_id"], name: "index_follows_on_followable"
    t.index ["follower_id", "follower_type"], name: "fk_follows"
    t.index ["follower_type", "follower_id"], name: "index_follows_on_follower"
  end

  create_table "members", force: :cascade do |t|
    t.bigint "article_id"
    t.bigint "user_id"
    t.string "role"
    t.boolean "active"
    t.decimal "weight"
    t.decimal "weight_n"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_members_on_article_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "pairwise_comparisons", force: :cascade do |t|
    t.integer "comparable1_id"
    t.string "comparable1_type"
    t.integer "comparable2_id"
    t.string "comparable2_type"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "appraisal_id"
    t.index ["appraisal_id"], name: "index_pairwise_comparisons_on_appraisal_id"
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

  create_table "rankings", force: :cascade do |t|
    t.bigint "article_id"
    t.bigint "user_id"
    t.bigint "member_id"
    t.string "type"
    t.bigint "alternative_id"
    t.decimal "score"
    t.integer "rank_no"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alternative_id"], name: "index_rankings_on_alternative_id"
    t.index ["article_id"], name: "index_rankings_on_article_id"
    t.index ["member_id"], name: "index_rankings_on_member_id"
    t.index ["user_id"], name: "index_rankings_on_user_id"
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "alternatives", "articles"
  add_foreign_key "appraisals", "criteria"
  add_foreign_key "appraisals", "members"
  add_foreign_key "articles", "users"
  add_foreign_key "comparisons", "appraisals"
  add_foreign_key "criteria", "articles"
  add_foreign_key "members", "articles"
  add_foreign_key "members", "users"
  add_foreign_key "pairwise_comparisons", "appraisals"
  add_foreign_key "properties", "alternatives"
  add_foreign_key "properties", "articles"
  add_foreign_key "rankings", "alternatives"
  add_foreign_key "rankings", "articles"
  add_foreign_key "rankings", "members"
  add_foreign_key "rankings", "users"
end
