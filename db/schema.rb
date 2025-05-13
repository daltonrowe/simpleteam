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

ActiveRecord::Schema[8.0].define(version: 2025_05_08_062634) do
  create_table "pending_seats", force: :cascade do |t|
    t.integer "team_id"
    t.string "email_address"
    t.string "token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_pending_seats_on_email_address"
    t.index ["team_id"], name: "index_pending_seats_on_team_id"
    t.index ["token"], name: "index_pending_seats_on_token"
  end

  create_table "seats", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_seats_on_team_id"
    t.index ["user_id"], name: "index_seats_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "user_id", null: false
    t.json "message"
    t.json "links"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["created_at"], name: "index_statuses_on_created_at"
    t.index ["team_id"], name: "index_statuses_on_team_id"
    t.index ["user_id"], name: "index_statuses_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "guid"
    t.integer "user_id", null: false
    t.string "name", limit: 120
    t.json "sections", default: {"yesterday"=>"Yesterday", "today"=>"Today"}
    t.datetime "notifaction_time"
    t.datetime "end_of_day"
    t.string "time_zone", default: "Central Time (US & Canada)"
    t.json "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "index_teams_on_guid"
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 60
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "pending_seats", "teams"
  add_foreign_key "seats", "teams"
  add_foreign_key "seats", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "statuses", "teams"
  add_foreign_key "statuses", "users"
  add_foreign_key "teams", "users"
end
