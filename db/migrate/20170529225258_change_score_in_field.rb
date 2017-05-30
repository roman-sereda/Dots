class ChangeScoreInField < ActiveRecord::Migration[5.1]
  def change
    change_column(:fields, :owner_score, :integer, default: 0)
    change_column(:fields, :guest_score, :integer, default: 0)
  end
end
