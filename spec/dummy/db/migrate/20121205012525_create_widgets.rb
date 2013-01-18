class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string  :name
      t.integer :counter_field
      t.string  :style

      t.timestamps
    end
  end
end
