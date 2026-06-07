namespace :blocked_email_domains do
  desc "Add blocked email domains to prevent signup from suspicious addresses"
  task :add, [:domains] => :environment do |_, args|
    domains = Array(args[:domains].to_s.split(",")).flat_map { |value| value.to_s.split(/[\s,]+/) }
    domains += Array(ENV.fetch("DOMAIN", "").to_s.split(/[\s,]+/))
    domains = domains.map(&:strip).reject(&:blank?).map { |domain| domain.sub(/\A@/, "").downcase }

    if domains.empty?
      raise ArgumentError, "Please provide one or more domains via blocked_email_domains:add[domain] or DOMAIN=domain"
    end

    domains.each do |domain|
      record = BlockedEmailDomain.find_or_create_by!(domain: domain)
      puts "Blocked domain: #{record.domain}"
    end
  end
end
