require "clockwork"
require_relative "../app/daily_job"
require_relative "../app/slack"

module Clockwork
  every(1.day, "Daily Job", tz: "Singapore", at: "16:00") do
    if DailyJob.perform_now
      Slack.ping!
    end
  end

  every(1.hour, "Health Check", at: "**:00") do
    Slack.ping!("I am still alive!")
  end

  error_handler do |error|
    Slack.log!("[data.rubyasia.com] " + error.to_s)
  end
end
