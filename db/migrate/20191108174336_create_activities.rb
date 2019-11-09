class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.bigint :user_id, null: false
      t.bigint :client_id, null: false
      t.bigint :project_id, null: false

      t.datetime :start
      t.integer :duration
      t.string :desc

      t.index [:user_id, :start]
      t.index [:client_id, :start]
      t.index [:project_id, :start]
    end
  end
end
