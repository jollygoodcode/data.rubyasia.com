require "octokit"

class DailyJob
  PROJECT_ROOT = File.expand_path("../..", __FILE__)

  def self.perform_now
    Dir.chdir(PROJECT_ROOT) do
      # fetch new changes
      system("git pull origin gh-pages")

      # run setup
      system("bin/setup")

      # new branch
      system("git checkout -b #{branch_name}")

      # update data/developers
      system("bundle exec rake fetch_developers[all]")

      # update data/repos
      system("bundle exec rake fetch_repos[all]")

      # regenerate index.html & archived/*.html
      system("bin/generate_all")

      # commit fetch_developers
      system("git add data/users")
      system("git commit -m 'Users Update on #{today}'")

      # commit repos
      system("git add data/repos")
      system("git commit -m 'Repos Update on #{today}'")

      # commit HTMLs
      system("git add index.html")
      system("git add archived/*.html")
      system("git commit -m 'Site Update on #{today}'")

      # Push the branch
      system("git push origin #{branch_name}")
    end

    sleep(60) # sleep one minute to wait branch to be created

    client.create_pull_request(
      "jollygoodcode/data.rubyasia.com", "gh-pages", branch_name, "Update on #{today}", ""
    )
  end

  def self.branch_name
    @_branch_name ||= "update-#{now.strftime("%F-%H%M%S")}"
  end
  private_class_method :branch_name

  def self.today
    now.strftime("%F")
  end
  private_class_method :today

  def self.now
    @_now ||= Time.now
  end
  private_class_method :now

  def self.client
    @_client ||= begin
      Octokit::Client.new(access_token: ENV.fetch("DATA_RUBYASIA_TOKEN"), auto_paginate: true)
    end
  end
  private_class_method :client
end
