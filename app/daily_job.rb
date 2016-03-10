class DailyJob
  def self.perform_now
    # fetch new changes
    system("git pull origin gh-pages")

    # run setup
    system("bin/setup")

    # new branch
    system("git checkout -b #{branch_name}")

    # update data/developers
    system("rake fetch_developers[all]")

    # update data/repos
    system("rake fetch_repos[all]")

    # regenerate index.html
    system("bin/generate")

    # commit developers
    system("git add data/users")
    system("git commit -m 'Users Update on #{today}'")

    # commit repos
    system("git add data/repos")
    system("git commit -m 'Repos Update on #{today}'")

    # commit html
    system("git add index.html")
    system("git commit -m 'Site Update on #{today}'")

    # Push the branch
    system("git push origin #{branch_name}")

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
