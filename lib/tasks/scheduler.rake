desc "This task is called by the Heroku scheduler add-on to query strava for new activities every 10 minutes"
task :fetch_activities => :environment do
  puts "Fetching new activities..."
  Activity.fetch_activities
  puts "Done."
end

desc "This task updates athlete profiles to reflect changes made in Strava"
task :sync_athletes => :environment do
  puts "Syncing athletes..."
  Athlete.sync_athletes
  puts "Done."
end