# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_30_201310) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "gigs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "notification_categories", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "from_user_id"
    t.bigint "to_user_id"
    t.text "description"
    t.boolean "checked"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "notification_category_id", null: false
    t.bigint "post_id"
    t.bigint "spost_id"
    t.index ["from_user_id"], name: "index_notifications_on_from_user_id"
    t.index ["notification_category_id"], name: "index_notifications_on_notification_category_id"
    t.index ["post_id"], name: "index_notifications_on_post_id"
    t.index ["spost_id"], name: "index_notifications_on_spost_id"
    t.index ["to_user_id"], name: "index_notifications_on_to_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "title"
    t.text "content"
    t.integer "price"
    t.bigint "category_id"
    t.bigint "user_id"
    t.string "gig_image", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_posts_on_category_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id"
    t.bigint "post_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_reviews_on_post_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "sposts", force: :cascade do |t|
    t.text "title"
    t.text "content"
    t.integer "price"
    t.bigint "category_id"
    t.bigint "user_id"
    t.string "seek_gig_image", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_sposts_on_category_id"
    t.index ["user_id"], name: "index_sposts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", default: "", null: false
    t.text "about", default: "", null: false
    t.string "profile_picture", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "stripe_user_id"
    t.bigint "notification_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["notification_id"], name: "index_users_on_notification_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "notifications", "notification_categories"
  add_foreign_key "notifications", "posts"
  add_foreign_key "notifications", "sposts"
  add_foreign_key "users", "notifications"
end
