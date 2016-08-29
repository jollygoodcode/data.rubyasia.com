require "clockwork"
require_relative "../app/daily_job"
require_relative "../app/slack"

module Clockwork
  every(1.day, "Daily Job", tz: "Singapore", at: "15:00") do
    DailyJob.sync_repo_and_restart_clockwork
  end

  every(1.day, "Daily Job", tz: "Singapore", at: "16:00") do
    DailyJob.perform_now
  end
end
