class CreateWotsits < ActiveRecord::Migration
  def change
    create_table :wotsits do |t|
      t.string :name
      t.references :widget
      t.references :gear
      t.timestamps
    end
  end
end
