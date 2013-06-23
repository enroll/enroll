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

ActiveRecord::Schema.define(version: 20130623223733) do


  create_table "courses", force: true do |t|
    t.string "name"
  end

  create_table "payouts", force: true do |t|
    t.integer "stripe_transfer_id"
    t.integer "stripe_recipient_id"
    t.string  "status"
    t.string  "description"
    t.integer "amount_in_cents"
  end

  add_index "payouts", ["status"], name: "index_payouts_on_status", using: :btree

  create_table "reservations", force: true do |t|
    t.integer "course_id"
  end

  add_index "reservations", ["course_id"], name: "index_reservations_on_course_id", using: :btree

end
