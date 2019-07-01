class ChangeColumnCalculatedAmount < ActiveRecord::Migration[5.2]
  change_column :timesheets, :calculated_amount, :float, null: true
end
