require "date"

class ExistingDate
  def self.all
    periods = Dir["data/repos/**/*.json"].map do |path|
      path.match(/2016-\d{2}-\d{2}_2016-\d{2}-\d{2}/).to_s
    end.uniq.sort_by do |period|
      get_end_date(period)
    end
  end

  def self.get_occurred_date_by(period)
    Date.parse(get_end_date(period)).next_day.to_s
  end

  # private

    def self.get_end_date(period)
      period.split("_".freeze).last
    end
    private_class_method :get_end_date
end
