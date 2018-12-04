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

ActiveRecord::Schema.define(version: 2018_12_04_190243) do

  create_table "stenographer_authentications", force: :cascade do |t|
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "credentials"
    t.text "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stenographer_changes", force: :cascade do |t|
    t.string "subject"
    t.string "message", null: false
    t.string "source_id"
    t.boolean "visible", default: true, null: false
    t.string "change_type"
    t.string "environments"
    t.string "tracker_ids"
    t.text "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stenographer_links", force: :cascade do |t|
    t.string "url"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stenographer_outputs", force: :cascade do |t|
    t.bigint "authentication_id", null: false
    t.text "configuration", null: false
    t.text "filters"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
