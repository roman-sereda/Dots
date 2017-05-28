class CreateFields < ActiveRecord::Migration[5.1]
  def change
    create_table :fields do |t|
      t.string :name, null: false
      t.string :points, array: true, default: []
    end
  end
end
