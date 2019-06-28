module TimeCalculations
  extend ActiveSupport::Concern

  def time_to_seconds_since_midnight(time)
    Time.parse(time).seconds_since_midnight
  end
end