class ClientNameUnique < ActiveRecord::Migration[6.0]
  def change
    remove_column :clients, :no_client, :boolean

    change_column_null :clients, :name, false, ''
    change_column_default :clients, :name, from: nil, to: ''

    remove_index :clients, :user_id
    add_index :clients, [:user_id, :name], unique: true
  end
end
