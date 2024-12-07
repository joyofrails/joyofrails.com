module Share
  module Polls
    class LazyPagePoll < ApplicationComponent
      include Phlex::Rails::Helpers::Provide
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::TurboRefreshesWith

      attr_reader :page, :title, :question_data
      def initialize(page, title, question_data = {})
        @page = page
        @title = title
        @question_data = question_data
      end

      def view_template
        poll = Poll.generate_for(page, title, question_data) or return
        turbo_frame_tag poll, src: share_poll_path(poll), class: "poll joy-border-subtle rounded"
      end
    end
  end
end
