class Timesheet < ApplicationRecord
  validates :date, :start_time, :finish_time, presence: true
  validate :date_cannot_be_in_the_future, :finish_time_cannot_be_before_start_time, :cannot_have_overlapping_timesheet_entries
  before_save :calculate_amount

  RATES_PER_HOUR = {
    %w(Monday Wednesday Friday) => {
      start_time: Time.parse("07:00").seconds_since_midnight,
      finish_time: Time.parse("19:00").seconds_since_midnight,
      inside_rate: 22,
      outside_rate: 33
    },
    %w(Tuesday Thursday) => {
      start_time: Time.parse("05:00").seconds_since_midnight,
      finish_time: Time.parse("17:00").seconds_since_midnight,
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
    overlapping_timesheets = Timesheet
                                    .where(date: date)
                                    .where('finish_time > ? AND ? > start_time', start_time, finish_time)

    if overlapping_timesheets.size > 0
      errors.add(:finish_time, "There is an existing timesheet that overlaps this date and time")
    end
  end

  private

  def calculate_amount
    day = self.date.strftime("%A")
    rates_hash = RATES_PER_HOUR.select { |key, hash| hash if key.include?(day) }.values.first
    
    @outside_rate = rates_hash[:outside_rate]
    @inside_rate = rates_hash[:inside_rate]
    @rates_start_time = seconds_to_hours(rates_hash[:start_time])
    @rates_finish_time = seconds_to_hours(rates_hash[:finish_time])
    @finish_time = seconds_to_hours(self.finish_time)
    @start_time = seconds_to_hours(self.start_time)

    no_overlap_or_outside_range = (@rates_start_time.nil? && @rates_finish_time.nil?) || !overlaps_time_range?
    return self.calculated_amount = ((@finish_time - @start_time) * @outside_rate).round(2) if no_overlap_or_outside_range
    return self.calculated_amount = timesheet_overlap_range_calculation.round(2)
  end

  def timesheet_overlap_range_calculation
    # within the range
    if @start_time >= @rates_start_time && @finish_time <= @rates_finish_time
      inside_amount = (@finish_time - @start_time) * @inside_rate
      outside_amount = 0
    # less than rate start and less than rate finish
    elsif (@start_time < @rates_start_time) && (@finish_time <= @rates_finish_time && @finish_time > @rates_start_time)
      outside_amount = (@rates_start_time - @start_time) * @outside_rate
      inside_amount = (@finish_time - @rates_start_time) * @inside_rate
    # greater than rate start and greater than rate finish
    elsif (@start_time >= @rates_start_time && @start_time < @rates_finish_time) && (@finish_time > @rates_finish_time)
      inside_amount = (@rates_finish_time - @start_time) * @inside_rate
      outside_amount = (@finish_time - @rates_finish_time) * @outside_rate
    # encompasses the range
    else
      outside_amount = (((@rates_start_time - @start_time) + (@finish_time - @rates_finish_time))) * @outside_rate
      inside_amount = (@rates_finish_time - @rates_start_time) * @inside_rate
    end

    return outside_amount + inside_amount
  end

  def seconds_to_hours(seconds)
    seconds.to_f / 3600
  end

  def overlaps_time_range?
    (@finish_time > @rates_start_time) && (@rates_finish_time > @start_time)
  end
end
