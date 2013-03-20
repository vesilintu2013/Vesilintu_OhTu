class CreatePlacesTable < ActiveRecord::Migration
  def up
    create_table :places do |t|
      t.integer :route_id
      t.integer :observation_place_number #1-999
      t.integer :nnn_coordinate #3+3 (3+['3'+2])
      t.integer :eee_coordinate #3+3 (3+['3'+2])
      t.integer :biotope_class #1-8
      t.string :observation_place_name
      t.float :place_area # myös null
      t.integer :area_covers_fully # alustavasti 0, 1 tai 2
      t.integer :covering_area_beginning # kattavuusalueen alku
      t.integer :covering_area_end # kattavuusalueen loppu
      t.timestamps
    end
  end

  def down
    drop_table :places
  end
end
