class AddScoreToField < ActiveRecord::Migration[5.1]
  def change
    add_column :fields, :owner_id, :integer
    add_column :fields, :guest_id, :integer
    add_column :fields, :owner_score, :integer
    add_column :fields, :guest_score, :integer

    add_column :fields, :is_finished, :bool
    add_column :fields, :turn, :integer, default: false
  end
end
