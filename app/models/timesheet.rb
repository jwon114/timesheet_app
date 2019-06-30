class Timesheet < ApplicationRecord
  validates :date, :start_time, :finish_time, presence: true
  validate :date_cannot_be_in_the_future, :finish_time_cannot_be_before_start_time, :cannot_have_overlapping_timesheet_entries
  before_save :calculate_amount

  RATES_PER_HOUR = {
    %w(Monday Wednesday Friday) => {
      start_time: Time.parse("07:00:00").seconds_since_midnight,
      finish_time: Time.parse("19:00:00").seconds_since_midnight,
      inside_rate: 22,
      outside_rate: 33
    },
    %w(Tuesday Thursday) => {
      start_time: Time.parse("05:00:00").seconds_since_midnight,
      finish_time: Time.parse("17:00:00").seconds_since_midnight,
      inside_rate: 25,
      outside_rate: 35
    },
    %w(Saturday Sunday) => {
      outside_rate: 47
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
    binding.pry
    day = date.strftime("%A")

    rates_hash = RATES_PER_HOUR.select { |key, hash| hash if key.include?(day) }.values.first

    rates_start_time = rates_hash[:start_time]
    rates_finish_time = rates_hash[:finish_time]

    if rates_hash.has_key?(:time_range)
      # within the range
      if start_time >= rates_start_time && finish_time <= rates_finish_time
        amount = ((finish_time - start_time) / 3600) * rates_hash[:inside_rate]
      # less than rate start and less than rate finish
      elsif start_time < rates_start_time && finish_time <= rates_finish_time
        outside_amount = ((rates_start_time - start_time) / 3600) * rates_hash[:outside_rate]
        inside_amount = ((finish_time - rates_start_time) / 3600) * rates_hash[:inside_rate]
        amount = outside_amount + inside_amount
      # greater than rate start and greater than rate finish
      elsif start_time >= rates_start_time && finish_time > rates_finish_time
        inside_amount = ((rates_finish_time - start_time) / 3600) * rates_hash[:inside_amount]
        outside_amount = ((finsh_time - rates_finish_time) / 3600) * rates_hash[:outside_rate]
        amount = outside_amount + inside_amount
      # encompasses the range
      else
        outside_amount = (((rates_start_time - start_time) / 3600) + ((finish_time - rates_finish_time) / 3600)) * rates_hash[:outside_rate]
        inside_amount = ((rates_start_time - rates_finish_time) / 3600) * rates_hash[:inside_rate]
        amount = outside_amount + inside_amount
      end
    else
      amount = rates_hash[:outside_rate] * ((finish_time - start_time) / 3600)
    end

    return amount
  end
end
