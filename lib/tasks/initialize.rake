namespace :watcher do
  task create: ['db:update'] do
    STDOUT.puts "\n\nWelcome!\n"
    STDOUT.puts "Which base URL would you like notifications to be sent to?"
    input = STDIN.gets.strip
    subscriber = Subscriber.create!({
      notification_url: input
    })

    puts "Watcher Key:\t\t#{subscriber.api_id}"
    puts "Watcher Secret:\t\t#{subscriber.api_key}"
    puts "Notification Key:\t#{subscriber.notifier_id}"
    puts "Notification Secret:\t#{subscriber.notifier_key}"
  end
end
