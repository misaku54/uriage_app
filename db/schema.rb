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

ActiveRecord::Schema[7.0].define(version: 2023_08_09_074315) do
  create_table "makers", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "user_id"], name: "index_makers_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_makers_on_user_id"
  end

  create_table "producttypes", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "user_id"], name: "index_producttypes_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_producttypes_on_user_id"
  end

  create_table "sales", charset: "utf8mb4", force: :cascade do |t|
    t.integer "amount_sold", null: false
    t.text "remark"
    t.bigint "user_id", null: false
    t.bigint "maker_id"
    t.bigint "producttype_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "created_on", null: false
    t.index ["created_on"], name: "fk_rails_49491b7fc3"
    t.index ["maker_id"], name: "index_sales_on_maker_id"
    t.index ["producttype_id"], name: "index_sales_on_producttype_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "weather_forecasts", primary_key: "aquired_on", id: :date, charset: "utf8mb4", force: :cascade do |t|
    t.integer "weather_id"
    t.float "temp_max"
    t.float "temp_min"
    t.float "rainfall_sum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "makers", "users"
  add_foreign_key "producttypes", "users"
  add_foreign_key "sales", "makers"
  add_foreign_key "sales", "producttypes"
  add_foreign_key "sales", "users"
  add_foreign_key "sales", "weather_forecasts", column: "created_on", primary_key: "aquired_on"
end
