class ActivitiesNotNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :activities, :start, false

    rename_column :activities, :duration, :length
    change_column_null :activities, :length, false
    change_column_default :activities, :length, from: nil, to: 0

    rename_column :activities, :desc, :description
    change_column_null :activities, :description, false
    change_column_default :activities, :description, from: nil, to: ''
  end
end
