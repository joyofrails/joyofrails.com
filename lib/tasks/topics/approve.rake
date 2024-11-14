namespace :topics do
  desc "Approve a set of topics given by comma separated slugs or names"
  task :approve, [:topics] => :environment do |t, args|
    topics = args[:topics].to_s.split(",").map(&:strip)

    Topic.where(slug: topics).or(Topic.where(name: topics)).find_each(&:approved!)
  end
end
