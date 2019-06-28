module TimesheetsHelper
  def seconds_since_midnight_to_time(seconds)
    Time.at(seconds).utc.strftime("%H:%M:%S")
  end
end
