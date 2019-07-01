require 'test_helper'

class TimesheetTest < ActiveSupport::TestCase
  def setup
    @ts = Timesheet.new
    @ts.date = Date.today
    @ts.start_time = Time.parse("03:00:00").seconds_since_midnight
    @ts.finish_time = Time.parse("05:00:00").seconds_since_midnight
    @ts.calculated_amount = 100
  end

  test 'date is required' do
    @ts.date = nil
    assert @ts.invalid?
  end

  test 'date is not in the future' do
    @ts.date = Date.today + 2.days
    assert @ts.invalid?
  end

  test 'start time is required' do
    @ts.start_time = nil
    assert @ts.invalid?
  end

  test 'finish time is required' do
    @ts.finish_time = nil
    assert @ts.invalid?
  end

  test 'finish time is before start time' do
    @ts.start_time = Time.parse("10:00:00").seconds_since_midnight
    @ts.finish_time = Time.parse("09:00:00").seconds_since_midnight
    assert @ts.invalid?
  end

  test 'no overlapping timesheets - start time is before new finish time and after new start time' do
    @ts.start_time = Time.parse("09:00:00").seconds_since_midnight
    @ts.finish_time = Time.parse("10:30:00").seconds_since_midnight
    assert @ts.invalid?
  end

  test 'no overlapping timesheets - start time is before new start time and finish time is after new finish time' do
    @ts.start_time = Time.parse("10:15:00").seconds_since_midnight
    @ts.finish_time = Time.parse("10:45:00").seconds_since_midnight
    assert @ts.invalid?
  end

  test 'no overlapping timesheets - finish time is after new start time and before new finish time' do
    @ts.start_time = Time.parse("10:45:00").seconds_since_midnight
    @ts.finish_time = Time.parse("11:30:00").seconds_since_midnight
    assert @ts.invalid?
  end

  test 'no overlapping timesheets - start time is after new start time and finish time is before new finish time' do
    @ts.start_time = Time.parse("09:00:00").seconds_since_midnight
    @ts.finish_time = Time.parse("11:45:00").seconds_since_midnight
    assert @ts.invalid?
  end

  test 'no overlapping timesheets - across two existing timesheets' do
    @ts.start_time = Time.parse("09:00:00").seconds_since_midnight
    @ts.finish_time = Time.parse("14:00:00").seconds_since_midnight
    assert @ts.invalid?
  end

  test '#calculate_amount - Monday 10am - 5pm' do
    @ts.date = Date.parse("2019/04/15")
    @ts.start_time = Time.parse("10:00:00").seconds_since_midnight
    @ts.finish_time = Time.parse("17:00:00").seconds_since_midnight
    assert_equal 154, @ts.send(:calculate_amount)
  end

  test '#calculate_amount - Tuesday 12:00pm - 8:15pm' do
    @ts.date = Date.parse("2019/04/16")
    @ts.start_time = Time.parse("12:00:00").seconds_since_midnight
    @ts.finish_time = Time.parse("20:15:00").seconds_since_midnight
    assert_equal 238.75, @ts.send(:calculate_amount)
  end

  test '#calculate_amount - Wednesday 4:00am - 9:30pm' do
    @ts.date = Date.parse("2019/04/17")
    @ts.start_time = Time.parse("04:00:00").seconds_since_midnight
    @ts.finish_time = Time.parse("21:30:00").seconds_since_midnight
    assert_equal 445.5, @ts.send(:calculate_amount)
  end

  test '#calculate_amount - Weekend 3:30pm - 8:00pm' do
    @ts.date = Date.parse("2019/04/20")
    @ts.start_time = Time.parse("15:30:00").seconds_since_midnight
    @ts.finish_time = Time.parse("20:00:00").seconds_since_midnight
    assert_equal 211.50, @ts.send(:calculate_amount)
  end

  test '#calculate_amount - Monday 11:00pm - 11:30pm' do
    byebug
    @ts.date = Date.parse("2019/04/22")
    @ts.start_time = Time.parse("23:00:00").seconds_since_midnight
    @ts.finish_time = Time.parse("23:30:00").seconds_since_midnight
    assert_equal 16.50, @ts.send(:calculate_amount)
  end
end
