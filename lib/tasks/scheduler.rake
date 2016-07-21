desc "This task is called by the Heroku scheduler add-on to query strava for new activities every 10 minutes"
task :fetch_activities => :environment do
  puts "Fetching new activities..."
  Activity.fetch_activities
  puts "Done."
end

desc "This task updates syncs the activities in the db with the ones on the strava server"
task :sync_activities => :environment do
  puts "Syncing activities..."
  rails r lib/sync_activities
  puts "Done."
end