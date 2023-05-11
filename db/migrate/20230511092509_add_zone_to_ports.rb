class AddZoneToPorts < ActiveRecord::Migration[7.0]
  def change
    add_column :ports, :zone, :string
  end
end
