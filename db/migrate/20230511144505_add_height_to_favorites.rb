class AddHeightToFavorites < ActiveRecord::Migration[7.0]
  def change
    add_column :favorites, :height, :float
  end
end
