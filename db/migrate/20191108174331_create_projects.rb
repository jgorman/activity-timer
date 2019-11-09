class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.references :user, null: false
      t.references :client, null: false

      t.string :name
      t.boolean :no_project, null: false, default: false

      t.timestamps
    end
  end
end
