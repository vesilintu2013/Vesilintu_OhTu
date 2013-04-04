class AddRktlFields < ActiveRecord::Migration
  def change
    add_column :observations, :rktl_telescope, :boolean
    add_column :places, :rktl_pog_society_id, :integer
    add_column :places, :rktl_town, :string
    add_column :places, :rktl_zip, :string
    add_column :places, :rktl_it, :string
    add_column :places, :rktl_map_number, :integer
    add_column :places, :rktl_map_name, :string
    add_column :places, :rktl_shore_length, :float
    add_column :places, :rktl_pog_zone_id, :integer
    add_column :places, :rktl_project, :string
    add_column :places, :rktl_place_not_counted, :boolean
    add_column :places, :rktl_other, :string
  end

end
