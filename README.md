# The official unoffical hybris beer consumption justification meter

As we work hard to stay in shape, one must wonder what is the amount of beer it would take to replenish the calories we burned.
This is where this application comes in.

https://beer-consumption-meter.herokuapp.com

## Installing the app locally
This app uses Rails 4.2.0

1. clone repo
2. cd into beer_champs
3. `bundle install --without production`
4. `rake db:migrate`

## Populating the app with data from Strava
In order to populate the database with data, you must create a [Strava](https://www.strava.com/) account and get your API key.
Set `STRAVA_TOKEN` as an environment variable on your machine equal to the access token you get from Strava.

If you would like to create a beer leaderboard for a different club, change the value of `@club_id` in `beer_champs/app/models/activity.rb`
to your desired club id.

If you would like to populate the database with the last 200 activities from your club (that's the max Strava returns for club
activities), run
```
rails runner lib/create_all_activities
```
You can optionally get less activities by providing the page number (starting with 1), and page size as parameters. For example
```
rails runner lib/create_all_activities 1 20
```
Will get the last 20 activities for your club.


If you would like to create leaderboards for those activities, run
```
rails runner lib/create_all_leaderboards
```

Start the rails server with `rails server` and go to http://localhost:3000. You can now select a date for your leaderboard.
