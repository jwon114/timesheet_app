class Timesheet < ApplicationRecord
  validates :date, :start_time, :finish_time, :calculated_amount, presence: true
  validate :date_cannot_be_in_the_future, :finish_time_cannot_be_before_start_time

  def date_cannot_be_in_the_future
    if date.present? && date > Date.today
      errors.add(:date, "Date cannot be in the past")
    end
  end

  def finish_time_cannot_be_before_start_time
    if finish_time.present? && start_time.present? && finish_time < start_time
      errors.add(:finish_time, "Finish time cannot be before start time")
    end
  end

  def time_to_seconds_since_midnight(time)
    Time.parse(time).seconds_since_midnight
  end
end
