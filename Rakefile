desc "List available regions to fetch data."
task :regions_list do
  puts IO.readlines("regions".freeze).map(&:chomp).join(", ".freeze)
end

desc "Fetch Repositories by specified region, or pass all to fetch repositories from all regions."
task :fetch_repos, [:region] do |t, args|
  abort "Please specify a region." if args[:region].nil?
  require_relative "app/repo"
  Repo.new(args[:region]).fetch_repositories
end

desc "Fetch Developers by specified region, or pass all to fetch developers from all regions."
task :fetch_developers, [:region] do |t, args|
  abort "Please specify a region." if args[:region].nil?
  require_relative "app/user"
  User.new(args[:region]).fetch_developers
end
