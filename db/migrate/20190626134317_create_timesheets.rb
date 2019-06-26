class CreateTimesheets < ActiveRecord::Migration[5.2]
  def change
    create_table :timesheets do |t|
      t.date :date, null: false
      t.time :start_time, null: false
      t.time :finish_time, null: false
      t.float :calculated_amount, null: false
      t.timestamps
    end
  end
end
