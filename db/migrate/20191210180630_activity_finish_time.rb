class ActivityFinishTime < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :finish, :datetime

    Activity.connection.execute("update activities set finish = start + length * interval '1 second'")

    change_column_null :activities, :finish, false
  end
end
