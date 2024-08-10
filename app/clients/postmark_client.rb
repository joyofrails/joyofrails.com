class PostmarkClient
  def self.deliver_messages(messages)
    new.deliver_messages(messages)
  end

  def deliver_messages(messages)
    api_client.deliver_messages(messages)
  end

  def api_client
    @api_client ||= Postmark::ApiClient.new(Rails.configuration.settings.postmark_api_token)
  end
end
