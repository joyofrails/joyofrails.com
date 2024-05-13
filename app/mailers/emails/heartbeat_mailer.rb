class Emails::HeartbeatMailer < ApplicationMailer
  def heartbeat
    @to = params[:to]

    mail(to: @to, subject: "It’s alive!")
  end
end
