class AddSurrenderToFields < ActiveRecord::Migration[5.1]
  def change
    add_column :fields, :owner_surrender, :bool, default: false
    add_column :fields, :guest_surrender, :bool, default: false
  end
end
