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

ActiveRecord::Schema.define(version: 20160626021244) do

  create_table "activities", force: :cascade do |t|
    t.string   "name"
    t.float    "distance"
    t.string   "activity_type"
    t.integer  "moving_time"
    t.float    "total_elevation_gain"
    t.integer  "calories"
    t.float    "start_lat"
    t.float    "start_long"
    t.float    "end_lat"
    t.float    "end_long"
    t.integer  "kudos_count"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "athlete_id"
    t.integer  "beers"
  end

  add_index "activities", ["athlete_id", "created_at"], name: "index_activities_on_athlete_id_and_created_at"
  add_index "activities", ["athlete_id"], name: "index_activities_on_athlete_id"

  create_table "athletes", force: :cascade do |t|
    t.string   "name"
    t.decimal  "calories"
    t.decimal  "beers"
    t.string   "img_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "username"
  end

  create_table "leaderboards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
