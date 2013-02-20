class CreateAdditionalObservations < ActiveRecord::Migration
  def up
    create_table :additional_observations do |t|
      t.integer :observation_id # viite havaintoon, johon lisälaji kuuluu
      t.string :species_code
      t.integer :count
      t.timestamps
    end
  end
  def down
    drop_table :additional_observations
  end
end
