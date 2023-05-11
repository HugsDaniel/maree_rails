class AddSlugToPorts < ActiveRecord::Migration[7.0]
  def change
    add_column :ports, :slug, :string
  end
end
