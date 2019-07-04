# Timesheet App

## Description
* Creates timesheet entries based on Date, Start Time and Finish Time.
* One view showing the list of timesheets created along with their dollar value.
* Another view for the timesheet create form.

## Validations
* Timesheet entries cannot overlap.
* Date of Entry, Start Time and Finish Time are required.
* Date of Entry cannot be in the future.
* Finish Time cannot be before Start Time.

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
