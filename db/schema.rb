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

ActiveRecord::Schema[7.0].define(version: 2022_07_19_025839) do
  create_table "colleges", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exam_windows", force: :cascade do |t|
    t.datetime "start"
    t.datetime "end"
    t.integer "exam_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_exam_windows_on_exam_id"
  end

  create_table "exams", force: :cascade do |t|
    t.string "name"
    t.integer "college_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["college_id"], name: "index_exams_on_college_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.datetime "start_time"
    t.integer "exam_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_registrations_on_exam_id"
    t.index ["user_id"], name: "index_registrations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone_number", "last_name", "first_name"], name: "index_users_on_phone_number_and_last_name_and_first_name", unique: true
  end

  add_foreign_key "exam_windows", "exams"
  add_foreign_key "exams", "colleges"
  add_foreign_key "registrations", "exams"
  add_foreign_key "registrations", "users"
end
