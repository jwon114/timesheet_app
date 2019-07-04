# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

timesheets = [
  {
    date: Date.today,
    start_time: Time.parse("09:00").seconds_since_midnight,
    finish_time: Time.parse("10:00").seconds_since_midnight
  },
  {
    date: Date.yesterday,
    start_time: Time.parse("12:00").seconds_since_midnight,
    finish_time: Time.parse("17:00").seconds_since_midnight
  },
  {
    date: Date.today - 1.week,
    start_time: Time.parse("06:00").seconds_since_midnight,
    finish_time: Time.parse("18:00").seconds_since_midnight
  },
  {
    date: Date.today - 2.weeks,
    start_time: Time.parse("11:00").seconds_since_midnight,
    finish_time: Time.parse("23:00").seconds_since_midnight
  }
]

timesheets.each { |ts| Timesheet.create(ts) }
