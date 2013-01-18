class CreateCogs < ActiveRecord::Migration
  def change
    create_table :cogs do |t|
      t.string :name

      t.timestamps
    end

    create_table :cogs_widgets, id: false do |t|
      t.references :cog
      t.references :widget
    end
  end
end
