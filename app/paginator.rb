require_relative "existing_date"

class Paginator
  def initialize(period)
    @period = period
  end

  def has_paginations?
    prev_path || next_path
  end

  def prev_path
    return unless prev_date

    File.join("", "archived", prev_date, "index.html")
  end

  def next_path
    return "/index.html" if current_index == all_dates.size - 2
    return unless next_date

    File.join("", "archived", next_date, "index.html")
  end

  private

    attr_reader :period

    def current_index
      @_current_index ||= all_dates.index(period)
    end

    def all_dates
      @_all_dates ||= ExistingDate.all
    end

    def prev_date
      return nil if current_index == 0

      ExistingDate.get_occurred_date_by(all_dates[current_index - 1]) if current_index > 0
    end

    def next_date
      return nil if current_index == all_dates.size - 1

      ExistingDate.get_occurred_date_by(all_dates[current_index + 1])
    end
end
