class CreateTimers < ActiveRecord::Migration[6.0]
  def change
    create_table :timers do |t|
      t.bigint :user_id, null: false
      t.bigint :project_id, null: false

      t.datetime :start, null: false
      t.string :description, default: '', null: false

      t.index ["user_id"], unique: true
    end
  end
end
