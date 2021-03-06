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
    @ts.start_time = Time.parse("10:00").seconds_since_midnight
    @ts.finish_time = Time.parse("09:00").seconds_since_midnight
    assert @ts.invalid?
  end

  test 'no overlapping timesheets - overlaps existing start time' do
    @ts.start_time = Time.parse("09:00").seconds_since_midnight
    @ts.finish_time = Time.parse("10:30").seconds_since_midnight
    assert @ts.invalid?
  end

  test 'no overlapping timesheets - within the time of existing timesheet' do
    @ts.start_time = Time.parse("10:15").seconds_since_midnight
    @ts.finish_time = Time.parse("10:45").seconds_since_midnight
    assert @ts.invalid?
  end

  test 'no overlapping timesheets - overlaps existing finish time' do
    @ts.start_time = Time.parse("10:45").seconds_since_midnight
    @ts.finish_time = Time.parse("11:30").seconds_since_midnight
    assert @ts.invalid?
  end

  test 'no overlapping timesheets - encompasses existing timesheet' do
    @ts.start_time = Time.parse("09:00").seconds_since_midnight
    @ts.finish_time = Time.parse("11:45").seconds_since_midnight
    assert @ts.invalid?
  end

  test 'no overlapping timesheets - across two existing timesheets' do
    @ts.start_time = Time.parse("09:00").seconds_since_midnight
    @ts.finish_time = Time.parse("14:00").seconds_since_midnight
    assert @ts.invalid?
  end

  test '#calculate_amount - Monday 10am - 5pm - within time range' do
    @ts.date = Date.parse("2019/04/15")
    @ts.start_time = Time.parse("10:00").seconds_since_midnight
    @ts.finish_time = Time.parse("17:00").seconds_since_midnight
    assert_equal 154, @ts.send(:calculate_amount)
  end

  test '#calculate_amount - Tuesday 12:00pm - 8:15pm - overlaps range finish time' do
    @ts.date = Date.parse("2019/04/16")
    @ts.start_time = Time.parse("12:00").seconds_since_midnight
    @ts.finish_time = Time.parse("20:15").seconds_since_midnight
    assert_equal 238.75, @ts.send(:calculate_amount)
  end

  test '#calculate_amount - Wednesday 4:00am - 9:30pm - encompasses entire range' do
    @ts.date = Date.parse("2019/04/17")
    @ts.start_time = Time.parse("04:00").seconds_since_midnight
    @ts.finish_time = Time.parse("21:30").seconds_since_midnight
    assert_equal 445.5, @ts.send(:calculate_amount)
  end

  test '#calculate_amount - Weekend 3:30pm - 8:00pm - no range overlap' do
    @ts.date = Date.parse("2019/04/20")
    @ts.start_time = Time.parse("15:30").seconds_since_midnight
    @ts.finish_time = Time.parse("20:00").seconds_since_midnight
    assert_equal 211.50, @ts.send(:calculate_amount)
  end

  test '#calculate_amount - Monday 11:00pm - 11:30pm - outside of range no overlap' do
    @ts.date = Date.parse("2019/04/22")
    @ts.start_time = Time.parse("23:00").seconds_since_midnight
    @ts.finish_time = Time.parse("23:30").seconds_since_midnight
    assert_equal 16.50, @ts.send(:calculate_amount)
  end

  test '#calculate_amount - Thursday 10:30pm - 10:35pm - rounding' do
    @ts.date = Date.parse("2019/07/04")
    @ts.start_time = Time.parse("22:30").seconds_since_midnight
    @ts.finish_time = Time.parse("22:35").seconds_since_midnight
    assert_equal 2.92, @ts.send(:calculate_amount)
  end
end
