class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.references :user, null: false

      t.string :name
      t.boolean :no_client, null: false, default: false

      t.timestamps
    end
  end
end
