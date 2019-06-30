require 'test_helper'
require 'pry'

class TimesheetTest < ActiveSupport::TestCase
  def setup
    @ts = Timesheet.new
    @ts.date = Date.today
    @ts.start_time = Time.parse("10:00:00").seconds_since_midnight
    @ts.finish_time = Time.parse("12:00:00").seconds_since_midnight
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
    assert_equal 238.78, @ts.send(:calculate_amount)
  end

  test '#calculate_amount - Wednesday 4:00am - 9:30pm' do
    @ts.date = Date.parse("2019/04/17")
    @ts.start_time = Time.parse("04:00:00").seconds_since_midnight
    @ts.finish_time = Time.parse("21:30:00").seconds_since_midnight
    assert_equal 445.50, @ts.send(:calculate_amount)
  end

  test '#calculate_amount - Weekend 3:30pm - 8:00pm' do
    @ts.date = Date.parse("2019/04/20")
    @ts.start_time = Time.parse("03:30:00").seconds_since_midnight
    @ts.finish_time = Time.parse("20:00:00").seconds_since_midnight
    binding.pry
    assert_equal 211.50, @ts.send(:calculate_amount)
  end
end
