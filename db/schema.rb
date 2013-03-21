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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130321141356) do

  create_table "birds", :force => true do |t|
    t.string   "name"
    t.string   "abbr"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "counts", :force => true do |t|
    t.integer  "observation_id"
    t.integer  "bird_id"
    t.integer  "count"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "observations", :force => true do |t|
    t.integer  "route_id"
    t.integer  "place_id"
    t.integer  "year"
    t.integer  "observer_id"
    t.date     "first_observation_date"
    t.date     "second_observation_date"
    t.integer  "first_observation_hour"
    t.integer  "first_observation_duration"
    t.integer  "second_observation_hour"
    t.integer  "second_observation_duration"
    t.boolean  "spot_counting"
    t.boolean  "binoculars"
    t.boolean  "boat"
    t.boolean  "gullbirds"
    t.boolean  "waders_eurasian_bittern"
    t.boolean  "passerine"
    t.string   "source"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "places", :force => true do |t|
    t.integer  "route_id"
    t.integer  "observation_place_number"
    t.integer  "nnn_coordinate"
    t.integer  "eee_coordinate"
    t.integer  "biotope_class"
    t.string   "observation_place_name"
    t.float    "place_area"
    t.integer  "area_covers_fully"
    t.integer  "covering_area_beginning"
    t.integer  "covering_area_end"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "source"
    t.string   "rktl_munincipal_code"
  end

  create_table "routes", :force => true do |t|
    t.integer  "route_number"
    t.integer  "year"
    t.string   "municipal_code",                  :limit => 6
    t.integer  "route_representative_class"
    t.integer  "spot_observation_place_count"
    t.integer  "roaming_observation_place_count"
    t.float    "water_system_area"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

end
