class ActivityRemoveFinish < ActiveRecord::Migration[6.0]
  def change
    remove_column :activities, :finish, :datetime
  end
end
