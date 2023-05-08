class AddAttributesToPorts < ActiveRecord::Migration[7.0]
  def change
    add_column :ports, :height, :float
  end
end
