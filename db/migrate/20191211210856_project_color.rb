class ProjectColor < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :color, :integer, null: false, default: 0
  end
end
