module Share
  module Polls
    class LazyPagePoll < ApplicationComponent
      include Phlex::Rails::Helpers::Provide
      include Phlex::Rails::Helpers::Request
      include Phlex::Rails::Helpers::TurboRefreshesWith

      attr_reader :page, :title, :question_data
      def initialize(page, title, question_data = {})
        @page = page
        @title = title
        @question_data = question_data
      end

      def view_template
        poll = Poll.generate_for(page, title, question_data) or return

        provide :head, turbo_refreshes_with(method: :morph, scroll: :preserve)
        render Share::Polls::PollComponent.new(poll, device_uuid: device_uuid)
      end

      def device_uuid
        return "" unless helpers.request.key_generator

        helpers.cookies.signed[:device_uuid]
      end
    end
  end
end
