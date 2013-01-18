class CreateRevisions < ActiveRecord::Migration
  def change
    create_table :revisions do |t|
      t.string     :target_type, null: false
      t.string     :action, null: false
      t.references :target, null: false
      t.string     :whodunnit
      t.text       :object
      t.datetime   :created_at
    end

    add_index :revisions, [:target_type, :target_id]
  end
end
