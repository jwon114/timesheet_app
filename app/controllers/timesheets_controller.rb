class TimesheetsController < ApplicationController
  include TimeCalculations

  def index
    @timesheets = Timesheet.all
  end

  def new
    @timesheet = Timesheet.new
  end

  def create
    @timesheet = Timesheet.new
    @timesheet.date = params.dig(:timesheet, :date)
    @timesheet.start_time = time_to_seconds_since_midnight(params.dig(:timesheet, :start_time))
    @timesheet.finish_time = time_to_seconds_since_midnight(params.dig(:timesheet, :finish_time))
    @timesheet.calculated_amount = 100

    if @timesheet.save
      redirect_to "/timesheets"
    else
      render 'new'
    end
  end
end
