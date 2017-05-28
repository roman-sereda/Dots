class CreateFields < ActiveRecord::Migration[5.1]
  def change
    create_table :fields do |t|
      t.string :name, null: false
      t.text :points, array: true, default: []
    end
  end
end
