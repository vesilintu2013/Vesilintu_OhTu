class CreateRoutesTable < ActiveRecord::Migration
  def up
    create_table :routes do |t|
      t.integer :route_number
      t.integer :year #1986(?) - nykyinen vuosi
      t.string :municipal_code, :limit => 6 #kuusikirjaiminen
      t.integer :route_representative_class #0-3
      t.integer :spot_observation_place_count # <= tiedossa olevat
      t.integer :roaming_observation_place_count # <= tiedossa olevat
      t.float :water_system_area # myös null
    end
  end

  def down
    drop_table :routes
  end
end
