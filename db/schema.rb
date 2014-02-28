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

ActiveRecord::Schema.define(version: 20140228081442) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_schedules", force: true do |t|
    t.integer "course_id"
    t.date    "date"
    t.integer "starts_at"
    t.integer "ends_at"
  end

  create_table "courses", force: true do |t|
    t.string   "name"
    t.string   "tagline"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.text     "description"
    t.integer  "location_id"
    t.integer  "instructor_id"
    t.integer  "min_seats",                        default: 0
    t.integer  "max_seats"
    t.integer  "price_per_seat_in_cents"
    t.text     "instructor_biography"
    t.string   "url"
    t.datetime "campaign_ends_at"
    t.datetime "campaign_failed_at"
    t.datetime "campaign_ending_soon_reminded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "instructor_paid_at"
    t.datetime "published_at"
  end

  add_index "courses", ["location_id"], name: "index_courses_on_location_id", using: :btree
  add_index "courses", ["url"], name: "index_courses_on_url", using: :btree

  create_table "cover_images", force: true do |t|
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.float    "offset"
  end

  create_table "events", force: true do |t|
    t.string   "event_type"
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
  end

  create_table "locations", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address_2"
  end

  create_table "marketing_tokens", force: true do |t|
    t.string   "token"
    t.string   "distinct_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "payouts", force: true do |t|
    t.string  "stripe_transfer_id"
    t.string  "stripe_recipient_id"
    t.string  "status"
    t.string  "description"
    t.integer "amount_in_cents"
  end

  add_index "payouts", ["status"], name: "index_payouts_on_status", using: :btree

  create_table "reservations", force: true do |t|
    t.integer  "course_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_token"
    t.datetime "charge_succeeded_at"
    t.string   "charge_failure_message"
    t.integer  "charge_amount"
  end

  add_index "reservations", ["course_id"], name: "index_reservations_on_course_id", using: :btree
  add_index "reservations", ["student_id"], name: "index_reservations_on_student_id", using: :btree

  create_table "resources", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "s3_url"
    t.string   "transloadit_assembly_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
    t.string   "resource_type"
    t.string   "link"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_customer_id"
    t.string   "name"
    t.string   "stripe_recipient_id"
    t.string   "visitor_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
