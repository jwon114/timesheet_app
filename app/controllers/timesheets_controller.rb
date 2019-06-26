class TimesheetsController < ApplicationController
  def index
    @timesheet_entries = Timesheet.all
  end

  def new
    puts 'hello'
  end
end
