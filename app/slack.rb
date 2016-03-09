require "http"

class Slack
  def self.ping!(message = TEXT)
    payload = {
      channel: CHANNEL,
      text: message,
      username: DISPLAY_USERNAME,
      icon_emoji: EMOJI,
    }.each { |_, v| v.freeze }.freeze

    HTTP.post(API_ENDPOINT, json: payload)
  end

  def self.log!(error)
    ping!(error)
  end

  # private

    CHANNEL = ENV["CHANNEL"]
    TEXT = ENV["TEXT"]
    DISPLAY_USERNAME = ENV["DISPLAY_USERNAME"]
    EMOJI = ENV["EMOJI"]
    API_ENDPOINT = ENV["API_ENDPOINT"]

    private_constant :CHANNEL
    private_constant :TEXT
    private_constant :DISPLAY_USERNAME
    private_constant :EMOJI
    private_constant :API_ENDPOINT
end
