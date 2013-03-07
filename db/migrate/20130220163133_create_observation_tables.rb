class CreateObservationTables < ActiveRecord::Migration
  def up
    create_table :observations do |t|
      t.integer :route_number
      t.integer :year #1986(?) - nykyinen vuosi
      t.integer :observation_place_number #1-999
      t.integer :observer_id #validoidaan Tipu-Apissa
      t.string :municipal_code, :limit => 6 #kuusikirjaiminen
      t.integer :nnn_coordinate #3+3 (3+['3'+2])
      t.integer :eee_coordinate #3+3 (3+['3'+2])
      t.integer :biotope_class #1-8
      t.integer :route_representative_class #0-3
      t.integer :spot_observation_place_count # <= tiedossa olevat
      t.integer :roaming_observation_place_count # <= tiedossa olevat
      t.string :observation_place_name
      t.date :first_observation_date # integer -> päivä
      t.date :second_observation_date # integer -> päivä
      t.integer :first_observation_hour # 0-23
      t.integer :first_observation_duration # 1-999
      t.integer :second_observation_hour # 0-23
      t.integer :second_observation_duration # 1-999
      t.float :water_system_area # myös null
      t.float :place_area # myös null
      t.integer :area_covers_fully # alustavasti 0, 1 tai 2
      t.integer :covering_area_beginning # kattavuusalueen alku
      t.integer :covering_area_end # kattavuusalueen loppu
      t.boolean :spot_counting # true = piste, false = kierto
      t.boolean :binoculars
      t.boolean :boat
      t.boolean :gullbirds 
      t.boolean :waders_eurasian_bittern 
      t.boolean :passerine 
      t.string :source # RKTL or museum
      t.timestamps
    end
  end

  def down
    drop_table :observations
  end
end
