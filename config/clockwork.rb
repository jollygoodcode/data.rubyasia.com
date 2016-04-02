require "clockwork"
require_relative "../app/daily_job"
require_relative "../app/slack"

module Clockwork
  every(1.day, "Daily Job", tz: "Singapore", at: "15:00") do
    success = DailyJob.sync_repo_and_restart_clockwork

    if success
      Slack.ping!("Repository synced and restarted clockwork")
    else
      Slack.ping!("Repository synced failed.")
    end
  end

  every(1.day, "Daily Job", tz: "Singapore", at: "16:00") do
    sent = DailyJob.perform_now

    if sent && sent.respond_to?(:html_url)
      Slack.ping!("Pull Request opened: #{sent.html_url}")
    else
      Slack.ping!("Something went wrong!")
    end
  end

  every(1.hour, "Health Check", at: "**:00") do
    Slack.ping!("I am still alive!")
  end

  error_handler do |error|
    Slack.log!("[data.rubyasia.com] " + error.to_s)
  end
end
