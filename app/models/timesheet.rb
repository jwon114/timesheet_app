class Timesheet < ApplicationRecord
  validates :date, :start_time, :finish_time, presence: true
  validate :date_cannot_be_in_the_future, :finish_time_cannot_be_before_start_time, :cannot_have_overlapping_timesheet_entries
  before_validation :calculate_amount

  RATES_PER_HOUR = {
    %w(Monday Wednesday Friday) => {
      time_range: (Time.parse("07:00:00").seconds_since_midnight..Time.parse("19:00:00").seconds_since_midnight),
      inside: 22,
      default: 33
    },
    %w(Tuesday Thursday) => {
      time_range: (Time.parse("05:00:00").seconds_since_midnight..Time.parse("17:00:00").seconds_since_midnight),
      inside: 25,
      default: 35
    },
    %w(Saturday Sunday) => {
      default: 47
    }
  }

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

  def cannot_have_overlapping_timesheet_entries

  end

  private

  def calculate_amount
    day = self.date.strftime("%A")
    start_time = self.start_time
    finish_time = self.finish_time

    rates_hash = RATES_PER_HOUR.select { |key, hash| hash if key.include?(day) }.values.first
    rate = rates_hash[:]
    if rates_hash.has_key?(:time_range) && 
      
    end
  end
end
