# frozen_string_literal: true

# https://plausible.io/docs/events-api#endpoints
#
# curl -i -X POST https://plausible.io/api/event \
#   -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36 OPR/71.0.3770.284' \
#   -H 'X-Forwarded-For: 127.0.0.1' \
#   -H 'Content-Type: application/json' \
#   --data '{"name":"pageview","url":"http://dummy.site","domain":"dummy.site"}'

class PlausibleClient < ApplicationClient
  base_uri "https://plausible.io/api"

  DOMAIN = "joyofrails.com"

  def post_event(name:, url:, referrer: nil, props: nil, headers: {})
    post(
      "/event",
      body: {
        name:,
        url:,
        referrer:,
        props:,
        domain: DOMAIN
      }.reject { |_, v| v.nil? },
      headers: headers.reverse_merge("Content-Type" => "application/json")
    )
  end
end
