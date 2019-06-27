require 'test_helper'
require 'pry'

class TimesheetTest < ActiveSupport::TestCase
  def setup
    @ts = Timesheet.new
    @ts.date = Date.today
    @ts.start_time = Time.now.seconds_since_midnight
    @ts.finish_time = (Time.now + 1.hour).seconds_since_midnight
    @ts.calculated_amount = 100
  end

  test '#index - retrieving all timesheets' do
    assert_equal 2, Timesheet.all.size
  end

  test '#new - valid timesheet' do
    assert @ts.valid?
  end

  test '#new - date is required' do
    @ts.date = nil
    assert_not @ts.valid?
  end

  test '#new - date is not in the future' do
    @ts.date = Date.tomorrow
    assert_not @ts.valid?
  end

  test '#new - start time is required' do
    @ts.start_time = nil
    assert_not @ts.valid?
  end

  test '#new - finish time is required' do
    @ts.finish_time = nil
    assert_not @ts.valid?
  end

  test '#new - finish time is before start time' do
    @ts.start_time = Time.now.seconds_since_midnight
    @ts.finish_time = (Time.now - 1.hour).seconds_since_midnight
    assert_not @ts.valid?
  end

  test '#new - calculations Monday, Wednesday, Friday' do

  end

  test '#new - calculations Tuesday, Thursday' do

  end

  test '#new - calculations weekend' do

  end

  test '#new - new timesheet is created' do

  end
end
