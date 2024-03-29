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

ActiveRecord::Schema[7.0].define(version: 2023_08_27_161224) do
  create_table "eyeloupe_exceptions", force: :cascade do |t|
    t.string "hostname"
    t.string "kind"
    t.string "location"
    t.string "file"
    t.integer "line"
    t.text "stacktrace"
    t.string "message"
    t.integer "count", default: 1
    t.text "full_message"
    t.integer "in_request_id"
    t.integer "out_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["in_request_id"], name: "index_eyeloupe_exceptions_on_in_request_id"
    t.index ["kind", "file", "line"], name: "index_eyeloupe_exceptions_on_kind_and_file_and_line"
    t.index ["out_request_id"], name: "index_eyeloupe_exceptions_on_out_request_id"
  end

  create_table "eyeloupe_in_requests", force: :cascade do |t|
    t.string "verb"
    t.string "hostname"
    t.string "controller"
    t.string "path"
    t.string "format"
    t.integer "status"
    t.integer "duration"
    t.integer "db_duration"
    t.integer "view_duration"
    t.string "ip"
    t.text "payload"
    t.text "headers"
    t.text "session"
    t.text "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "eyeloupe_jobs", force: :cascade do |t|
    t.string "classname"
    t.string "job_id"
    t.string "queue_name"
    t.string "adapter"
    t.integer "status", default: 0
    t.datetime "scheduled_at"
    t.datetime "executed_at"
    t.datetime "completed_at"
    t.integer "retry", default: 0
    t.string "args"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_eyeloupe_jobs_on_job_id", unique: true
  end

  create_table "eyeloupe_out_requests", force: :cascade do |t|
    t.string "verb"
    t.string "hostname"
    t.string "path"
    t.string "format"
    t.integer "status"
    t.integer "duration"
    t.text "payload"
    t.text "req_headers"
    t.text "res_headers"
    t.text "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "eyeloupe_exceptions", "eyeloupe_in_requests", column: "in_request_id"
  add_foreign_key "eyeloupe_exceptions", "eyeloupe_out_requests", column: "out_request_id"
end
