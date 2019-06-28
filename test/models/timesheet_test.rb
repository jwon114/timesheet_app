require 'test_helper'
require 'pry'

class TimesheetTest < ActiveSupport::TestCase
  def setup
    @ts = Timesheet.new
    @ts.date = Date.today
    @ts.start_time = 80086.463309
    @ts.finish_time = 80089.294483
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
    @ts.start_time = 86186.012718
    @ts.finish_time = 82604.518353 
    assert @ts.invalid?
  end

  test 'calculations Monday, Wednesday, Friday' do

  end

  test 'calculations Tuesday, Thursday' do

  end

  test 'calculations weekend' do

  end
end
