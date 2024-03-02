namespace :fixtures do
  task html: :environment do
    File.write(Rails.root.join("app", "javascript", "test", "fixtures", "views", "darkmode", "switch.html"), ApplicationController.render(partial: "darkmode/switch"))
  end
end
