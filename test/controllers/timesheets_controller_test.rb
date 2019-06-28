require 'test_helper'
require 'pry'

class TimesheetsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @ts = Timesheet.new
    @ts.date = Date.today
    @ts.start_time = 80086.463309
    @ts.finish_time = 80089.294483
    @ts.calculated_amount = 100
  end

  test '#index - retrieving all timesheets' do
    assert_equal 2, Timesheet.count
  end

  test '#new - valid timesheet' do
    assert @ts.valid?
  end

  test '#create - new timesheet is created' do
    assert_difference 'Timesheet.count' do
      @ts.save
    end
  end
end
