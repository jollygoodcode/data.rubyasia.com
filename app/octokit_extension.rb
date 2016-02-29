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
end
