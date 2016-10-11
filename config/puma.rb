workers Integer(ENV['PUMA_PROCESSES'] || 2)
threads_count = Integer(ENV['PUMA_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        (ENV['WEI_WATCHERS_PORT'] || ENV['PORT'] || 3174)
environment (ENV['RACK_ENV'] || 'development')

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
