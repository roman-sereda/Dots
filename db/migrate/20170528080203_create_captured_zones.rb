class CreateCapturedZones < ActiveRecord::Migration[5.1]
  def change
    create_table :captured_zones do |t|
      t.integer :field_id
      t.integer :player_id
      t.text :points, array: true, default: []
    end
  end
end
