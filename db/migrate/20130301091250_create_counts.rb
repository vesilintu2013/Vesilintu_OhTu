class CreateCounts < ActiveRecord::Migration
  def change
    create_table :counts do |t|
      t.integer :observation_id
      t.string :abbr
      t.integer :count
    end
  end
end
