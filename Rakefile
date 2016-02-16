require "octokit"
require "fileutils"
require "json"

task :regions_list do
  puts IO.readlines("regions".freeze).map(&:chomp).join(", ".freeze)
end

desc "Fetch Developers by specified region, or pass all to fetch developers from all regions"
task :fetch_developers, [:region] do |t, args|
  begin
    class String
      def green
        "\e[32m#{self}\e[0m"
      end

      def red
        "\e[31m#{self}\e[0m"
      end
    end

    def puts_in_green(str)
      puts str.green
    end

    def normalize(str)
      str.split(" ".freeze).join("-".freeze).downcase
    end

    def denormalize(str)
      str.split("-".freeze).map(&:capitalize).join(" ".freeze)
    end

    user_specified_region = normalize(args[:region])
    abort "Please specify a region." if user_specified_region.nil?

    available_regions = IO.readlines("regions").map(&:chomp)
    noramlized_regions = available_regions.map { |region| normalize(region) }

    if user_specified_region == "all".freeze
       REGIONS = noramlized_regions
    else
      if noramlized_regions.include?(user_specified_region)
        REGIONS = [user_specified_region]
      else
        puts "Unknown specified region: #{user_specified_region}".red
        puts %(Available Regions:\n#{available_regions.join(", ".freeze)})
        abort "Or type 'all' to fetch all regions."
      end
    end

    def octokit_goes_to_bed
      puts "Retry in #{CLIENT.rate_limit.resets_in + 1} seconds"
      sleep(CLIENT.rate_limit.resets_in + 1)
    end

    DATA_FOLDER = "data".freeze
    DATA_USERS_FOLDER = "data/users".freeze

    def create_regions_dirs!
      if !File.exist?(DATA_FOLDER) || !File.exist?(DATA_USERS_FOLDER)
        puts_in_green "Created data folder.".freeze
        FileUtils.mkdir_p(DATA_USERS_FOLDER)
      end

      REGIONS.each do |region|
        if !File.exist?(dir = File.join(DATA_USERS_FOLDER, region))
          FileUtils.mkdir_p(dir)
          puts_in_green "Created #{dir} folder."
        end
      end
    end

    def retryable_octokit
      begin
        yield if block_given?
      rescue Octokit::TooManyRequests
        octokit_goes_to_bed
        retry
      end
    end

    def fetch_developers_by(region:)
      periods = [
        "2007-10-20..2010-12-31",
        "2011-01-01..2012-12-31",
        "2013-01-01..2015-12-31",
        "2016-01-01..2017-12-31",
      ]

      periods.map do |period|
        query = %Q(location:#{region} repos:>=1 language:Ruby created:#{period})

        CLIENT.search_users(query).items
      end
    end

    def json_file_name(region:, id:)
      File.join("data".freeze, "users".freeze, region, "#{id}.json")
    end

    def jsons_in_region(region:)
      Dir[File.join(DATA_USERS_FOLDER, region, "*.json".freeze)].size
    end

    CLIENT = begin
      Octokit::Client.new(access_token: ENV.fetch("DATA_RUBYASIA_TOKEN"), auto_paginate: true)
    end

    octokit_goes_to_bed if CLIENT.rate_limit.remaining == 0

    create_regions_dirs!

    REGIONS.each do |region|
      retryable_octokit do
        results_by_period = fetch_developers_by(region: region).reject(&:empty?)

        if results_by_period.empty?
          puts "No developers available in this region: #{region}.".red
        end

        results_by_period.each do |period_result|
          puts "Fetching #{period_result.size} rubyists from #{denormalize(region)}..."
          period_result.each do |result|
            json_file = json_file_name(region: region, id: result.id)

            if !File.exist?(json_file)
              IO.write json_file, JSON.pretty_generate(result.to_h)
              puts_in_green "Created #{json_file}."
            else
              puts_in_green "#{json_file} exists, skipped."
            end
          end
        end

        puts %(Total Rubyists in #{denormalize(region)}: #{jsons_in_region(region: region)})
      end
    end
  ensure
    class String
      remove_method :green
      remove_method :red
    end
  end
end # end of task
