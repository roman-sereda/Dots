class AddClosedToField < ActiveRecord::Migration[5.1]
  def change
    add_column :fields, :closed, :bool, default: false
  end
end
