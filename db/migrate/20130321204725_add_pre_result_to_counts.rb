class AddPreResultToCounts < ActiveRecord::Migration
  def change
    add_column :counts, :pre_result, :string
  end
end
