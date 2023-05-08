class AddAttributesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :draught, :float
    add_column :users, :security_margin, :float
  end
end
