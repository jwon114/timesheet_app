class TimesheetsController < ApplicationController
  def index
    @timesheets = Timesheet.all
  end

  def new
    @timesheet = Timesheet.new
  end

  def create
    date = params.dig(:timesheet, :date)
    start_time = params.dig(:timesheet, :start_time)
    finish_time = params.dig(:timesheet, :finish_time)

    @timesheet = Timesheet.new
    @timesheet.date = date
    @timesheet.start_time = Time.parse(start_time).seconds_since_midnight
    @timesheet.finish_time = Time.parse(finish_time).seconds_since_midnight

    if @timesheet.save
      redirect_to '/timesheets'
    else
      render 'new'
    end
  end
end
