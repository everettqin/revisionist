class CreateGears < ActiveRecord::Migration
  def change
    create_table :gears do |t|
      t.string :name

      t.timestamps
    end
  end
end
