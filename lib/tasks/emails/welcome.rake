namespace :emails do
  task welcome: :environment do
    User.recently_confirmed.find_each do |user|
      WelcomeNotifier.deliver_to(user)
    end
  end
end
