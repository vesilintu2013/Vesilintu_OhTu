class CreateObservationTables < ActiveRecord::Migration
  def up
    create_table :observations do |t|
      t.integer :route_number, :null => false
      t.integer :year, :null => false #1986(?) - nykyinen vuosi
      t.integer :observation_place_number, :null => false #1-999
      t.integer :observer_id, :null => false #validoidaan Tipu-Apissa
      t.string :municipal_code, :limit => 6, :null => false #kuusikirjaiminen
      t.integer :nnn_coordinate, :null => false #3+3 (3+['3'+2])
      t.integer :eee_coordinate, :null => false #3+3 (3+['3'+2])
      t.integer :biotope_class, :null => false #1-8
      t.integer :route_representative_class, :null => false #0-3
      t.integer :spot_observation_place_count, :null => false # <= tiedossa olevat
      t.integer :roaming_observation_place_count, :null => false # <= tiedossa olevat
      t.string :observation_place_name, :limit => 17, :null => false
      t.date :first_observation_date, :null => false # integer -> päivä
      t.date :second_observation_date, :null => false # integer -> päivä
      t.integer :first_observation_hour, :null => false # 0-23
      t.integer :first_observation_duration, :null => false # 1-999
      t.integer :second_observation_hour, :null => false # 0-23
      t.integer :second_observation_duration, :null => false # 1-999
      t.float :water_system_area # myös null
      t.float :place_area # myös null
      t.integer :area_covers_fully, :null => false # alustavasti 0, 1 tai 2
      t.integer :covering_area_beginning # kattavuusalueen alku
      t.integer :covering_area_end # kattavuusalueen loppu
      t.boolean :spot_counting, :null => false # true = piste, false = kierto
      t.boolean :binoculars, :null => false
      t.boolean :boat, :null => false
      t.integer :anapla, :null => false #???
      t.integer :anacre, :null => false
      t.integer :anaacu, :null => false
      t.integer :anacly, :null => false
      t.integer :aytfer, :null => false
      t.integer :buccia, :null => false
      t.integer :mermer, :null => false
      t.integer :fulatr, :null => false
      t.integer :gavarc, :null => false
      t.integer :podcri, :null => false
      t.integer :podgri, :null => false
      t.integer :podaur, :null => false
      t.integer :cygcyg, :null => false
      t.integer :ansfab, :null => false
      t.integer :bracan, :null => false
      t.integer :anapen, :null => false
      t.integer :anaque, :null => false
      t.integer :aytful, :null => false
      t.integer :melfus, :null => false
      t.integer :merser, :null => false
      t.integer :meralb, :null => false
      t.boolean :gullbirds, :null => false
      t.integer :larmin, :null => false
      t.integer :larrid, :null => false
      t.integer :larcan, :null => false
      t.integer :stehir, :null => false
      t.boolean :waders_eurasian_bittern, :null => false
      t.integer :galgal, :null => false
      t.integer :trigla, :null => false
      t.integer :trineb, :null => false
      t.integer :trioch, :null => false
      t.integer :acthyp, :null => false
      t.integer :numarq, :null => false
      t.integer :vanvan, :null => false
      t.integer :botste, :null => false
      t.boolean :passerine, :null => false
      t.integer :embsch, :null => false
      t.integer :acrsch, :null => false         
    end
  end

  def down
    drop_table :observations
  end
end
