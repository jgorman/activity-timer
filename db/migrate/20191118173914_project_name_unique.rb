class ProjectNameUnique < ActiveRecord::Migration[6.0]
  def change
    remove_column :projects, :no_project, :boolean

    change_column_null :projects, :name, false, ''
    change_column_default :projects, :name, from: nil, to: ''

    remove_index :projects, :client_id
    add_index :projects, [:client_id, :name], unique: true
  end
end
