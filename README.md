# Timesheet App

## Setup
* Download or clone repository
* Ensure PostgreSQL is installed
* Install gem dependencies
```
bundle install
```
* Create database
```
rails db:create
```
* Database migrations
```
rails db:migrate
```
* Start rails server
```
rails s
```

## Description
* Creates timesheet entries based on Date, Start Time and Finish Time
* One view showing the list of timesheets along with their dollar value
* Another view for the timesheet create form

## Validations
* Timesheet entries cannot overlap
* Date of Entry, Start Time and Finish Time are required
* Date of Entry cannot be in the future
* Finish Time cannot be before Start Time

## Calculations
* Monday, Wednesday, Friday
  * 7am - 7pm: $22/hour
  * Outside: $33/hour
* Tuesday, Thursday
  * 5am - 5pm: $25/hour
  * Outside: $35/hour
* Weekend
  * Always $47/hour

## Approach
* Index page for displaying existing timesheets
* New page for timesheet creation
* TDD with model and controller tests
* Calculations:
  * Determine whether there is an overlap in timesheet and rate range OR if there is no rate range supplied
  * No rate range or overlap, calculation equals the difference in start and finish time in hours multiplied by the outside rate, (finish time - start time) * outside rate
  * For overlaps, work out where the overlap in time has occurred (overlap rate start time, overlap finish time, encapsulate rate range)
  * If the time range falls within the given rate range then (finish time - start time) * inside rate

## Technologies
* Ruby on Rails
* PostgreSQL
* Bootstrap