module OctokitExtension
  def octokit_goes_to_bed
    puts "Retry in #{client.rate_limit.resets_in + 1} seconds"
    sleep(client.rate_limit.resets_in + 1)
  end

  def retryable_octokit
    begin
      yield if block_given?
    rescue Octokit::TooManyRequests
      octokit_goes_to_bed
      retry
    end
  end

  class NoReposFound
    def items
      []
    end
  end

  def retryable_search_repos(query, retry_count = 0)
    client.search_repos(query)
  rescue Octokit::UnprocessableEntity
    NoReposFound.new
  rescue Errno::ETIMEDOUT, Faraday::TimeoutError, Net::OpenTimeout, Faraday::ConnectionFailed => exception
    puts "Retrying searching repo with this query: #{query}\nRetried times: #{retry_count + 1}."
    if (retry_count += 1) < 5
      retry
    else
      raise exception
    end
  end
end
