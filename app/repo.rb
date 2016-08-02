require "fileutils"
require "json"
require "octokit"
require "pathname"

require_relative "constant"
require_relative "region"
require_relative "octokit_extension"

class Repo
  include OctokitExtension

  def initialize(raw_region, period)
    @raw_region = raw_region
    @regions = determine_by_user_specified_region(Region.normalize(raw_region))
    @period = period
  end

  def fetch_repositories
    create_regions_dirs!

    regions.each do |region|
      retryable_octokit do
        total_user_logins = fetch_devs_from(region: region)

        results = total_user_logins.each_slice(SLICE_NUMBER).flat_map do |user_logins|
          fetch_repos_by(user_logins.join(" ".freeze), criteria)
        end.reject(&:empty?)

        if results.empty?
          puts "No repositories matched criteria available in this region: #{region}."
        else
          repos_json = Constant::ROOT.join DATA_REPOS_FOLDER, region, filename
          output = Hash(
            generated_at: Time.now.utc.strftime("%F %T %Z".freeze),
            criteria: criteria,
            repos: parse_results(results, region)
          )

          IO.write repos_json, JSON.pretty_generate(output)
          puts "#{repos_json} created."

          puts %(Total Repos trending this week in #{Region.denormalize(region)}: #{results.size} repos)
        end
      end
    end
  end

  private

    DATA_USERS_FOLDER = "data/users".freeze
    DATA_REPOS_FOLDER = "data/repos".freeze
    SLICE_NUMBER = 300

    private_constant :DATA_USERS_FOLDER
    private_constant :DATA_REPOS_FOLDER
    private_constant :SLICE_NUMBER

    attr_reader :raw_region, :regions, :period

    def determine_by_user_specified_region(user_specified_region)
      if user_specified_region == "all".freeze
        Region::NORMALIZED_REGIONS
      else
        if Region::NORMALIZED_REGIONS.include?(user_specified_region)
          [user_specified_region]
        else
          puts "Unknown specified region: #{user_specified_region}"
          puts %(Available Regions:\n#{Region::AVAILABLE_REGIONS.join(", ".freeze)})
          abort "Or type 'all' to fetch all regions."
        end
      end
    end

    def client
      @client ||= begin
        Octokit::Client.new(access_token: ENV.fetch("DATA_RUBYASIA_TOKEN"), auto_paginate: true)
      end
    end

    def create_regions_dirs!
      regions.each do |region|
        if !File.exist?(dir = File.join(DATA_REPOS_FOLDER, region))
          FileUtils.mkdir_p(dir)
          puts "Created #{dir} folder."
        end
      end
    end

    def fetch_devs_from(region:)
      Dir[
        Constant::ROOT.join(DATA_USERS_FOLDER, region, "*.json".freeze).to_s
      ].map { |user_json| %(user:#{JSON.parse(IO.read(user_json))["login"]}) }
    end

    def criteria
      "language:Ruby stars:>20 pushed:#{period}"
    end

    def fetch_repos_by(user_logins, criteria)
      retryable_search_repos(%(#{user_logins} #{criteria})).items
    end

    def parse_results(results, region)
      results.inject([]) do |acc, result|
        acc << Hash(
          full_name: result.full_name,
          description: result.description,
          html_url: result.html_url,
          stars: result.stargazers_count,
          language: result.language,
          region: Region.denormalize(region)
        )
      end.sort_by { |repo| repo[:stars] }.reverse
    end

    def filename
      %(repos-#{period.sub("..".freeze, "_".freeze)}.json)
    end
end
