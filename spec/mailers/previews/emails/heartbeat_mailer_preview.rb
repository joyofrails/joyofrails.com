# Preview all emails at http://localhost:3000/rails/mailers/mailers/heartbeat
class Emails::HeartbeatMailerPreview < ActionMailer::Preview
  def heartbeat
    Emails::HeartbeatMailer.with(to: "hello@joyofrails.com").heartbeat
  end
end
