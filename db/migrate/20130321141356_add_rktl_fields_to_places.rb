class AddRktlFieldsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :source, :string
    add_column :places, :rktl_munincipal_code, :string
  end
end
