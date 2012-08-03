set :output, "/path/to/my/cron_log.log"

every 1.hour do
  rake 'app:clean_pictures', output: 'log/cron.log'
end