require "fileutils"
require "json"
require "octokit"
require "pathname"

require_relative "normalizer"
require_relative "octokit_extension"

class User
  include Normalizer
  include OctokitExtension

  ROOT = Pathname(File.expand_path(File.join(File.dirname(__FILE__), '..'.freeze)))
  DATA_USERS_FOLDER = "data/users".freeze
  PERIODS = [
    "2007-10-20..2010-12-31",
    "2011-01-01..2012-12-31",
    "2013-01-01..2015-12-31",
    "2016-01-01..2017-12-31",
  ].freeze

  def initialize(raw_region)
    @raw_region = raw_region
    @available_regions = IO.readlines(ROOT.join("regions")).map(&:chomp)
    @noramlized_regions = available_regions.map { |region| normalize(region) }
    @regions = determin_by_user_specified_region(normalize(raw_region))
  end

  def client
    @client ||= begin
      Octokit::Client.new(access_token: ENV.fetch("DATA_RUBYASIA_TOKEN"), auto_paginate: true)
    end
  end

  def determin_by_user_specified_region(user_specified_region)
    if user_specified_region == "all".freeze
      noramlized_regions
    else
      if noramlized_regions.include?(user_specified_region)
        [user_specified_region]
      else
        puts "Unknown specified region: #{user_specified_region}"
        puts %(Available Regions:\n#{available_regions.join(", ".freeze)})
        abort "Or type 'all' to fetch all regions."
      end
    end
  end

  def create_regions_dirs!
    regions.each do |region|
      if !File.exist?(dir = File.join(DATA_USERS_FOLDER, region))
        FileUtils.mkdir_p(dir)
        puts "Created #{dir} folder."
      end
    end
  end

  def fetch_developers
    create_regions_dirs!

    regions.each do |region|
      retryable_octokit do
        results_by_period = fetch_developers_by(region: region).reject(&:empty?)

        if results_by_period.empty?
          puts "No developers available in this region: #{region}."
        end

        results_by_period.each do |period_result|
          puts "Fetching #{period_result.size} rubyists from #{denormalize(region)}..."
          period_result.each do |result|
            json_file = json_file_name(region: region, id: result.id)

            if !File.exist?(json_file)
              IO.write json_file, JSON.pretty_generate(result.to_h)
              puts "Created #{json_file}."
            else
              puts "#{json_file} exists, skipped."
            end
          end
        end

        puts %(Total Rubyists in #{denormalize(region)}: #{jsons_in_region(region: region)})
      end
    end
  end

  def fetch_developers_by(region:)
    PERIODS.map do |period|
      client.search_users(%(location:#{region} repos:>=1 language:Ruby created:#{period})).items
    end
  end

  def json_file_name(region:, id:)
    File.join("data".freeze, "users".freeze, region, "#{id}.json")
  end

  def jsons_in_region(region:)
    Dir[File.join(DATA_USERS_FOLDER, region, "*.json".freeze)].size
  end

  private

    attr_reader :raw_region, :available_regions, :noramlized_regions, :regions
end
