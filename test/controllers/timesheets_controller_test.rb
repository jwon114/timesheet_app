require 'test_helper'

class TimesheetsControllerTest < ActionDispatch::IntegrationTest
  test '#index - retrieving all timesheets' do
    assert_equal 3, Timesheet.count
  end

  test '#create - new timesheet is created' do
    assert_difference 'Timesheet.count' do
      post '/timesheets', params: {
        timesheet: {
          date: Date.today,
          start_time: "03:00",
          finish_time: "05:00"
        }
      }
    end

    assert_redirected_to '/timesheets'
  end
end
