require "json"
require "date"
require "twemoji"

class View
  attr_reader :repos

  def initialize(recent_period)
    @repos = Dir["data/repos/**/repos-#{recent_period}.json"].
      flat_map { |region| JSON.parse(IO.read(region))["repos"] }.
      sort_by { |r| r["stars"] }.reverse
  end

  def emojify(content)
    Twemoji.parse(content, file_ext: "svg")
  end
end
