require "json"
require "date"
require "twemoji"

class View
  attr_reader :repos

  def initialize
    @repos = Dir["data/repos/**/repos-#{recent_period}.json"].
      flat_map { |region| JSON.parse(IO.read(region))["repos"] }.
      sort_by { |r| r["stars"] }.reverse
  end

  def emojify(content)
    Twemoji.parse(content, file_ext: ".svg")
  end

  private

    def recent_period
      %(#{Date.today.prev_day(7).strftime}_#{Date.today.prev_day.strftime})
    end
end
