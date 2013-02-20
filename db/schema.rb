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

ActiveRecord::Schema.define(:version => 20130220165145) do

  create_table "additional_observations", :force => true do |t|
    t.integer  "observation_id"
    t.string   "species_code"
    t.integer  "count"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "observations", :force => true do |t|
    t.integer  "route_number",                                  :null => false
    t.integer  "year",                                          :null => false
    t.integer  "observation_place_number",                      :null => false
    t.integer  "observer_id",                                   :null => false
    t.string   "municipal_code",                  :limit => 6,  :null => false
    t.integer  "nnn_coordinate",                                :null => false
    t.integer  "eee_coordinate",                                :null => false
    t.integer  "biotope_class",                                 :null => false
    t.integer  "route_representative_class",                    :null => false
    t.integer  "spot_observation_place_count",                  :null => false
    t.integer  "roaming_observation_place_count",               :null => false
    t.string   "observation_place_name",          :limit => 17, :null => false
    t.date     "first_observation_date",                        :null => false
    t.date     "second_observation_date",                       :null => false
    t.integer  "first_observation_hour",                        :null => false
    t.integer  "first_observation_duration",                    :null => false
    t.integer  "second_observation_hour",                       :null => false
    t.integer  "second_observation_duration",                   :null => false
    t.float    "water_system_area"
    t.float    "place_area"
    t.integer  "area_covers_fully",                             :null => false
    t.integer  "covering_area_beginning"
    t.integer  "covering_area_end"
    t.boolean  "spot_counting",                                 :null => false
    t.boolean  "binoculars",                                    :null => false
    t.boolean  "boat",                                          :null => false
    t.integer  "anapla",                                        :null => false
    t.integer  "anacre",                                        :null => false
    t.integer  "anaacu",                                        :null => false
    t.integer  "anacly",                                        :null => false
    t.integer  "aytfer",                                        :null => false
    t.integer  "buccia",                                        :null => false
    t.integer  "mermer",                                        :null => false
    t.integer  "fulatr",                                        :null => false
    t.integer  "gavarc",                                        :null => false
    t.integer  "podcri",                                        :null => false
    t.integer  "podgri",                                        :null => false
    t.integer  "podaur",                                        :null => false
    t.integer  "cygcyg",                                        :null => false
    t.integer  "ansfab",                                        :null => false
    t.integer  "bracan",                                        :null => false
    t.integer  "anapen",                                        :null => false
    t.integer  "anaque",                                        :null => false
    t.integer  "aytful",                                        :null => false
    t.integer  "melfus",                                        :null => false
    t.integer  "merser",                                        :null => false
    t.integer  "meralb",                                        :null => false
    t.boolean  "gullbirds",                                     :null => false
    t.integer  "larmin",                                        :null => false
    t.integer  "larrid",                                        :null => false
    t.integer  "larcan",                                        :null => false
    t.integer  "stehir",                                        :null => false
    t.boolean  "waders_eurasian_bittern",                       :null => false
    t.integer  "galgal",                                        :null => false
    t.integer  "trigla",                                        :null => false
    t.integer  "trineb",                                        :null => false
    t.integer  "trioch",                                        :null => false
    t.integer  "acthyp",                                        :null => false
    t.integer  "numarq",                                        :null => false
    t.integer  "vanvan",                                        :null => false
    t.integer  "botste",                                        :null => false
    t.boolean  "passerine",                                     :null => false
    t.integer  "embsch",                                        :null => false
    t.integer  "acrsch",                                        :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

end
