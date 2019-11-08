class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.references :project, null: false, foreign_key: true
      t.string :desc
      t.datetime :start
      t.integer :duration

      t.timestamps
    end
  end
end
