class ActivityName < ActiveRecord::Migration[6.0]
  def change
    rename_column :activities, :description, :name
    rename_column :timers, :description, :name
  end
end
