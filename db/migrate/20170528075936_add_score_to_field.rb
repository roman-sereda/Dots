class AddScoreToField < ActiveRecord::Migration[5.1]
  def change
    add_column :fields, :player_one_id, :integer
    add_column :fields, :player_two_id, :integer
    add_column :fields, :player_one_score, :integer
    add_column :fields, :player_two_score, :integer
  end
end
