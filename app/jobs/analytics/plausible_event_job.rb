class Analytics::PlausibleEventJob < ApplicationJob
  def perform(name:, url:, referrer: nil, props: nil, headers: {})
    result = PlausibleClient.new.post_event(name:, url:, referrer:, props:, headers: headers)

    Rails.logger.info("[#{self.class}] Plausible event posted: #{result.code} #{result.body}")
    Honeybadger.event("Plausible event", {code: result.code, body: result.body})
  end
end
