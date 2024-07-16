class Analytics::PlausibleEventJob < ApplicationJob
  def perform(name:, url:, referrer: nil, props: nil, headers: {})
    result = PlausibleClient.new.post_event(name:, url:, referrer:, props:, headers: headers)

    if result.code.to_i >= 300
      Rails.logger.warn("[#{self.class}] Plausible event unexpected response: #{result.code} #{result.body}")
    else
      Rails.logger.info("[#{self.class}] Plausible event posted: #{result.code} #{result.body}")
    end
  end
end
