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

    true
  end

  def self.branch_name
    @_branch_name ||= "update-#{now.strftime("%F-%H%M%S")}"
  end

  def self.today
    now.strftime("%F")
  end

  def self.now
    @_now ||= Time.now
  end
end
