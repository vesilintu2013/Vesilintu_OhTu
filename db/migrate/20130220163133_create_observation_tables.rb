class CreateObservationTables < ActiveRecord::Migration
  def up
    create_table :observations do |t|
      t.integer :route_id
      t.integer :place_id
      t.integer :year #1986(?) - nykyinen vuosi
      t.integer :observer_id #validoidaan Tipu-Apissa
      t.date :first_observation_date # integer -> päivä
      t.date :second_observation_date # integer -> päivä
      t.integer :first_observation_hour # 0-23
      t.integer :first_observation_duration # 1-999
      t.integer :second_observation_hour # 0-23
      t.integer :second_observation_duration # 1-999
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
