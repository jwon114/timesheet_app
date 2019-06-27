class CreateTimesheets < ActiveRecord::Migration[5.2]
  def change
    create_table :timesheets do |t|
      t.date :date, null: false
      t.float :start_time, null: false
      t.float :finish_time, null: false
      t.float :calculated_amount, null: false
      t.timestamps
    end
  end
end
