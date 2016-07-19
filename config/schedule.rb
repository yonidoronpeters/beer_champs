# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

every 10.minutes do
  puts "Fetching new activities..."
  runner "Activity.fetch_activities"
  puts "Done."
end

# Learn more: http://github.com/javan/whenever
