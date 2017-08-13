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

ActiveRecord::Schema.define(version: 20170806235851) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "discovery_search_terms", force: :cascade do |t|
    t.string "search_term"
    t.integer "radius"
    t.datetime "last_query"
  end

  create_table "hashtags", force: :cascade do |t|
    t.string "name"
  end

  create_table "instagram_photos", force: :cascade do |t|
    t.string "photo_id"
    t.string "url"
    t.bigint "user_id"
    t.boolean "scraped"
    t.string "gender"
    t.boolean "liked", default: false
    t.index ["url", "photo_id", "user_id"], name: "index_instagram_photos_on_url_and_photo_id_and_user_id"
    t.index ["url"], name: "index_instagram_photos_on_url", unique: true
  end

  create_table "instagram_users", force: :cascade do |t|
    t.string "username"
    t.boolean "followed"
    t.datetime "last_liked"
    t.boolean "ignored"
    t.string "instagram_id"
    t.bigint "user_id"
    t.index ["username"], name: "index_instagram_users_on_username", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.string "latitude"
    t.string "longitude"
    t.string "name"
    t.string "instagram_id"
    t.integer "user_id"
  end

  create_table "user_hashtags", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "hashtag_id"
    t.index ["hashtag_id"], name: "index_user_hashtags_on_hashtag_id"
    t.index ["user_id"], name: "index_user_hashtags_on_user_id"
  end

  create_table "user_locations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "location_id"
    t.index ["location_id"], name: "index_user_locations_on_location_id"
    t.index ["user_id"], name: "index_user_locations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
