class Timesheet < ApplicationRecord
  validates :date, :start_time, :finish_time, presence: true
end
