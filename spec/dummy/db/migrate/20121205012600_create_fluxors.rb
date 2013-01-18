class CreateFluxors < ActiveRecord::Migration
  def change
    create_table :fluxors do |t|
      t.string :name
      t.references :widget

      t.timestamps
    end
  end
end
