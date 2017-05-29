class ChangeScoreInField < ActiveRecord::Migration[5.1]
  def change
    change_column(:fields, :player_one_score, :integer, default: 0)
    change_column(:fields, :player_two_score, :integer, default: 0)
  end
end
