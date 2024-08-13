module Analytics
  extend ActiveSupport::Concern

  def plausible_event(name, props: {})
    Analytics::PlausibleEventJob.perform_later(
      name: name,
      url: request.original_url,
      props: props,
      referrer: request.referer,
      headers: {
        "User-Agent" => request.user_agent,
        "X-Forwarded-For" => request.remote_ip
      }
    )
  end
end
