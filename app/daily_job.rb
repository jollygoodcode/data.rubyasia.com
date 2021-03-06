require "octokit"

class DailyJob
  PROJECT_ROOT = File.expand_path("../..", __FILE__)

  def self.sync_repo_and_restart_clockwork
    Dir.chdir(PROJECT_ROOT) do
      # checkout to gh-pages
      system("git checkout gh-pages")

      # fetch new changes
      system("git pull origin gh-pages")

      # run setup
      system("bin/setup")

      # restart clockwork
      system("bin/restart_clockwork")
    end
  end

  def self.perform_now
    Dir.chdir(PROJECT_ROOT) do
      # checkout to gh-pages
      system("git checkout gh-pages")

      # fetch new changes
      system("git pull origin gh-pages")

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
      system("git push origin gh-pages")
    end
  end

  def self.today
    now.strftime("%F")
  end
  private_class_method :today

  def self.now
    Time.now
  end
  private_class_method :now

  def self.client
    @_client ||= begin
      Octokit::Client.new(access_token: ENV.fetch("DATA_RUBYASIA_TOKEN"), auto_paginate: true)
    end
  end
  private_class_method :client
end
