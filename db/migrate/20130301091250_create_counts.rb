class CreateCounts < ActiveRecord::Migration
  def change
    create_table :counts do |t|
      t.integer :observation_id
      t.integer :bird_id
      t.integer :count

      t.timestamps
    end
  end
end
