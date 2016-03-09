require "clockwork"
require_relative "../app/daily_job"
require_relative "../app/slack"

module Clockwork
  every(1.day, "Daily Job", tz: "Singapore", at: "09:00") do
    if DailyJob.perform_now
      Slack.ping!
    end
  end

  error_handler do |error|
    Slack.log!("[data.rubyasia.com] " + error.to_s)
  end
end
