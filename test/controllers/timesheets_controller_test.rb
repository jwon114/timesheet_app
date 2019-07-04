require 'test_helper'

class TimesheetsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @ts = Timesheet.new
    @ts.date = Date.today
    @ts.start_time = Time.parse("03:00").seconds_since_midnight
    @ts.finish_time = Time.parse("05:00").seconds_since_midnight
    @ts.calculated_amount = 100
  end

  test '#index - retrieving all timesheets' do
    assert_equal 3, Timesheet.count
  end

  test '#create - new timesheet is created' do
    assert_difference 'Timesheet.count' do
      @ts.save
    end
  end
end
