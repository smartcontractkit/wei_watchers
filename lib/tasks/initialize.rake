namespace :watcher do
  task create: ['db:update'] do
    STDOUT.puts "\n\nWelcome!\n"
    STDOUT.puts "Which base URL would you like notifications to be sent to?"
    input = STDIN.gets.strip
    subscriber = Subscriber.create!({
      notification_url: input
    })

    puts "USERNAME:\t\t#{subscriber.api_id}"
    puts "PASSWORD:\t\t#{subscriber.api_key}"
    puts "NOTIFICATION USERNAME:\t#{subscriber.notifier_id}"
    puts "NOTIFICATION PASSWORD:\t#{subscriber.notifier_key}"
  end
end
